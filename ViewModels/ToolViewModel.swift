import Observation

@Observable
final class ToolViewModel {
    
    var input = ""
    var subnetMask = ""
    var result = "Press the button to start."
    var selectedRecord: DNSRecordType = .a
    private let ipCalculator = IPCalculatorService()
    func execute(tool: NetworkTool) {
        switch tool {
        case .ping:
            result = "Ping işlemi yakında eklenecek."
        case .dns:
            result = "DNS sorgusu yakında eklenecek."
        case .whois:
            result = "WHOIS sorgusu yakında eklenecek."
        case .traceroute:
            result = "Traceroute yakında eklenecek."
        case .portScan:
            result = "Port taraması yakında eklenecek."
        case .ipCalculator:

            guard let result = ipCalculator.calculate(
                ip: input,
                subnetMask: subnetMask
            ) else {

                self.result = "Invalid IP address."

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
