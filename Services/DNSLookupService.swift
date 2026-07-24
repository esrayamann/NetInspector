import Foundation

struct DNSLookupService {

    func lookup(
        domain: String,
        type: DNSRecordType
    ) async throws -> DNSLookupResult {

        let domain = domain
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        guard !domain.isEmpty else {
            throw URLError(.badURL)
        }

        let urlString =
        "https://dns.google/resolve?name=\(domain)&type=\(type.queryValue)"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let response = try JSONDecoder().decode(
            DNSResponse.self,
            from: data
        )

        let records = response.Answer?.map(\.data) ?? []

        return DNSLookupResult(
            domain: domain,
            recordType: type,
            records: records
        )

    }

}
