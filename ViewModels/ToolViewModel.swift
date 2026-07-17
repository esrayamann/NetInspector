import Observation

@Observable
final class ToolViewModel {

    var input = ""
    var result = "Henüz sorgu yapılmadı."
    var selectedRecord: DNSRecordType = .a

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
            result = "IP Calculator yakında eklenecek."
        }
    }
}
