import Foundation
import Network

struct PingService {

    func ping(
        host: String,
        count: Int = 5
    ) async throws -> PingStatistics {
        let host = host.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !host.isEmpty else {
            throw URLError(.badURL)
        }

        let ip = try await resolve(host: host)

        var values: [Double] = []

        for _ in 0..<count {
            try Task.checkCancellation()

            let latency = try await singlePing(
                host: host,
                port: 443
            )

            values.append(latency)

            try? await Task.sleep(for: .milliseconds(500))
        }

        return PingStatistics(
            host: host,
            ip: ip,
            values: values
        )
    }
    
    private func singlePing(
        host: String,
        port: UInt16
    ) async throws -> Double {

        guard let nwPort = NWEndpoint.Port(rawValue: port) else {
            throw URLError(.badURL)
        }

        let connection = NWConnection(
            host: NWEndpoint.Host(host),
            port: nwPort,
            using: .tcp
        )

        let start = Date()

        return try await withThrowingTaskGroup(of: Double.self) { group in
            group.addTask {
                let stream = AsyncThrowingStream<Double, Error> { continuation in
                    connection.stateUpdateHandler = { state in
                        switch state {
                        case .ready:
                            continuation.yield(Date().timeIntervalSince(start) * 1000)
                            continuation.finish()
                        case .failed(let error):
                            continuation.finish(throwing: error)
                        case .cancelled:
                            continuation.finish(throwing: CancellationError())
                        default:
                            break
                        }
                    }

                    connection.start(queue: .global())
                }

                for try await latency in stream {
                    return latency
                }

                throw URLError(.cannotConnectToHost)
            }

            group.addTask {
                try await Task.sleep(for: .seconds(5))
                connection.cancel()
                throw URLError(.timedOut)
            }

            defer {
                connection.cancel()
                group.cancelAll()
            }

            guard let latency = try await group.next() else {
                throw URLError(.cannotConnectToHost)
            }

            return latency
        }
    }

    
    // MARK: DNS Resolve

    private func resolve(host: String) async throws -> String {

        let addresses = try await DnsResolver.resolve(host)

        guard let first = addresses.first else {
            throw URLError(.cannotFindHost)
        }

        return first
    }

}
