import Foundation

struct WhoisService {

    func lookup(domain: String) async throws -> String {

        let domain = domain
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        guard !domain.isEmpty else {
            throw URLError(.badURL)
        }

        guard
            !domain.contains("/"),
            let encodedDomain = domain.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
            let url = URL(string: "https://rdap.org/domain/\(encodedDomain)")
        else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            return "Invalid server response."
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            return "WHOIS information could not be retrieved. (HTTP \(httpResponse.statusCode))"
        }

        let rdapResponse = try JSONDecoder().decode(
            RDAPResponse.self,
            from: data
        )

        var output = ""

        output += "Domain\n"
        output += "\(rdapResponse.ldhName ?? "-")\n\n"

        if let events = rdapResponse.events {

            for event in events {

                output += "\(event.eventAction)\n"
                output += "\(event.eventDate)\n\n"

            }

        }

        if let servers = rdapResponse.nameservers {

            output += "Name Servers\n"

            for server in servers {

                output += "\(server.ldhName ?? "-")\n"

            }

        }

        return output

    }

}
