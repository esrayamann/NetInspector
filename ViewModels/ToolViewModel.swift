import Observation
import Foundation

@MainActor @Observable
final class ToolViewModel {
    static let maximumPortRange = 1_024

    var input = ""
    var subnetMask = ""
    var result = "Press the button to start."
    var selectedRecord: DNSRecordType = .a
    var startPort = "1"
    var endPort = "1024"
    var openPorts: [PortScanResult] = []
    var isScanning = false
    var progress: Double = 0
    var scannedPorts = 0
    var totalPorts = 0
    var scanDuration: Double = 0
    var scanResults: [PortScanResult] = []
    var pingHost = ""
    var pingIP = ""
    var pingReplies: [Double] = []
    var isPinging = false
    var dnsResult: DNSLookupResult?
    var isLookingUpDNS = false

    var isWorking: Bool {
        isScanning || isPinging || isLookingUpDNS
    }

    private let ipCalculator = IPCalculatorService()
    private let dnsService = DNSLookupService()
    private let whoisService = WhoisService()
    private let portScanner = PortScannerService()
    private let portService = PortService()
    private let pingService = PingService()

    func execute(tool: NetworkTool) async {
        let target = input.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !target.isEmpty else {
            result = "Enter a host, domain, or IP address to continue."
            return
        }

        input = target

        switch tool {
        case .ping:

            pingReplies.removeAll()
            pingHost = ""
            pingIP = ""

            isPinging = true

            defer {
                isPinging = false
            }

            do {

                let stats = try await pingService.ping(host: target)

                pingHost = stats.host
                pingIP = stats.ip
                pingReplies = stats.values

                result = ""

            } catch {

                result = """
                Host Unreachable

                \(error.localizedDescription)
                """
            }
        case .dns:

            dnsResult = nil
            isLookingUpDNS = true

            defer {
                isLookingUpDNS = false
            }

            do {

                let lookup = try await dnsService.lookup(
                    domain: target,
                    type: selectedRecord
                )

                dnsResult = lookup
                result = ""

            } catch {

                result = error.localizedDescription

            }

        case .whois:
            do {

                result = try await whoisService.lookup(
                    domain: target
                )

            } catch {

                result = error.localizedDescription

            }
        case .traceroute:
            result = "Traceroute yakında eklenecek."
        case .portScan:

            guard
                let start = Int(startPort),
                let end = Int(endPort),
                (1...65_535).contains(start),
                (1...65_535).contains(end),
                start <= end,
                end - start + 1 <= Self.maximumPortRange
            else {
                result = "Enter a valid range between 1 and 65535 (up to \(Self.maximumPortRange) ports at a time)."
                return
            }

            let startTime = Date()

            isScanning = true
            scannedPorts = 0
            totalPorts = end - start + 1
            progress = 0
            scanResults.removeAll()
            scanDuration = 0
            result = ""

            let ports = await portScanner.scan(
                host: target,
                from: start,
                to: end
            ){ scanned, total in
                
                Task { @MainActor in
                    self.scannedPorts = scanned
                    self.progress = Double(scanned) / Double(total)
                }

            }
            
            isScanning = false
            
            let duration = Date().timeIntervalSince(startTime)

            scanDuration = duration

            if ports.isEmpty {

                scanResults = []

                result = """
                No open ports found.

                Scan completed in \(String(format: "%.2f", duration)) seconds.
                """

            } else {

                scanResults = ports.map { port in
                    PortScanResult(
                        port: port,
                        service: portService.serviceName(for: port)
                    )
                }

                result = ""

            }
            
            case .ipCalculator:

            guard let result = ipCalculator.calculate(
                ip: target,
                subnetMask: subnetMask
            ) else {

                self.result = "Enter a valid IPv4 address and a contiguous subnet mask."

                return
            }

            self.result = """

            Network Address
            \(result.networkAddress)

            Broadcast Address
            \(result.broadcastAddress)

            First Host
            \(result.firstHost)

            Last Host
            \(result.lastHost)

            Host Count
            \(result.hostCount)

            """
        }
    }

}
