import Foundation
import Network

struct PingService {

    func ping(
        host: String,
        count: Int = 5
    ) async throws -> PingStatistics {
        
        // DNS çözümlemesi
        let ip = try await resolve(host: host)

        var values: [Double] = []

        for _ in 0..<count {

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

        return try await withCheckedThrowingContinuation { continuation in

            connection.stateUpdateHandler = { state in

                switch state {

                case .ready:

                    let latency = Date().timeIntervalSince(start) * 1000

                    connection.cancel()

                    continuation.resume(returning: latency)

                case .failed(let error):

                    connection.cancel()

                    continuation.resume(throwing: error)

                default:
                    break
                }
            }

            connection.start(queue: .global())
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
