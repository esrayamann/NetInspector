//
//  PortScannerService.swift
//  NetInspector
//

import Foundation
import Network

struct PortScannerService {

    // MARK: - Single Port

    func scan(host: String, port: Int) async -> Bool {

        guard let nwPort = NWEndpoint.Port(rawValue: UInt16(port)) else {
            return false
        }

        let connection = NWConnection(
            host: NWEndpoint.Host(host),
            port: nwPort,
            using: .tcp
        )

        return await withTaskGroup(of: Bool.self) { group in

            // Connection sonucu
            group.addTask {

                let stream = AsyncStream<Bool> { continuation in

                    connection.stateUpdateHandler = { state in

                        switch state {

                        case .ready:
                            continuation.yield(true)
                            continuation.finish()

                        case .failed(_):
                            continuation.yield(false)
                            continuation.finish()

                        case .cancelled:
                            continuation.finish()

                        default:
                            break
                        }

                    }

                    connection.start(queue: .global())
                }

                for await value in stream {
                    return value
                }

                return false
            }

            // Timeout
            group.addTask {

                try? await Task.sleep(for: .seconds(1))
                return false

            }

            let result = await group.next() ?? false

            connection.cancel()
            group.cancelAll()

            return result
        }
    }

    // MARK: - Port Range

    func scan(
        host: String,
        from startPort: Int,
        to endPort: Int,
        progress: @escaping @Sendable (Int, Int) -> Void
    ) async -> [Int] {
        let total = endPort - startPort + 1

        var completed = 0
        
        let ports = Array(startPort...endPort)

        var openPorts: [Int] = []

        for chunk in ports.chunked(into: 20) {

            await withTaskGroup(of: Int?.self) { group in

                for port in chunk {

                    group.addTask {

                        let open = await scan(
                            host: host,
                            port: port
                        )

                        return open ? port : nil

                    }

                }

                for await result in group {
                    
                    completed += 1
                    
                    progress(completed, total)

                    if let port = result {
                        openPorts.append(port)
                    }
                    
                }

            }
            
        }
        
        return openPorts.sorted()

    }
    
}
