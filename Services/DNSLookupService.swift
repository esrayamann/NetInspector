import Foundation

enum DNSLookupError: LocalizedError {
    case invalidDomain
    case invalidResponse
    case server(statusCode: Int)
    case queryFailed(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .invalidDomain:
            return "Enter a valid domain name."
        case .invalidResponse:
            return "The DNS service returned an invalid response."
        case .server(let statusCode):
            return "The DNS service returned HTTP \(statusCode)."
        case .queryFailed(let statusCode):
            return "The DNS query failed (status \(statusCode))."
        }
    }
}

struct DNSLookupService {

    func lookup(
        domain: String,
        type: DNSRecordType
    ) async throws -> DNSLookupResult {

        let domain = domain
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        guard !domain.isEmpty else {
            throw DNSLookupError.invalidDomain
        }

        var components = URLComponents(string: "https://dns.google/resolve")
        components?.queryItems = [
            URLQueryItem(name: "name", value: domain),
            URLQueryItem(name: "type", value: String(type.queryValue))
        ]

        guard let url = components?.url else {
            throw DNSLookupError.invalidDomain
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw DNSLookupError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw DNSLookupError.server(statusCode: httpResponse.statusCode)
        }

        let dnsResponse = try JSONDecoder().decode(
            DNSResponse.self,
            from: data
        )

        guard dnsResponse.Status == 0 else {
            throw DNSLookupError.queryFailed(statusCode: dnsResponse.Status)
        }

        let records = dnsResponse.Answer?.map(\.data) ?? []

        return DNSLookupResult(
            domain: domain,
            recordType: type,
            records: records
        )

    }

}
