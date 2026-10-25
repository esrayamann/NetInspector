//
//  IPCalculatorService.swift
//  NetInspector
//
//  Created by Esra Yaman on 18.07.2026.
//

import Foundation

struct IPCalculatorService {

    func calculate(ip: String, subnetMask: String) -> IPCalculationResult? {

        guard
            let ipOctets = octets(from: ip),
            let maskOctets = octets(from: subnetMask),
            isValidSubnetMask(maskOctets)
        else {
            return nil
        }

        let network = networkAddress(ip: ipOctets, mask: maskOctets)

        let broadcast = broadcastAddress(
            network: network,
            mask: maskOctets
        )

        let prefix = prefixLength(from: maskOctets)

        let first: [UInt8]
        let last: [UInt8]
        let hosts: Int

        switch prefix {
        case 32:
            first = network
            last = network
            hosts = 1
        case 31:
            // RFC 3021 point-to-point subnets use both addresses.
            first = network
            last = broadcast
            hosts = 2
        default:
            first = firstHost(from: network)
            last = lastHost(from: broadcast)
            hosts = hostCount(prefix: prefix)
        }

        return IPCalculationResult(

            networkAddress: string(from: network),

            broadcastAddress: string(from: broadcast),

            firstHost: string(from: first),

            lastHost: string(from: last),

            hostCount: hosts
        )
    }
    
    private func octets(from address: String) -> [UInt8]? {

        let parts = address.split(separator: ".")

        guard parts.count == 4 else {
            return nil
        }

        let numbers = parts.compactMap {
            UInt8($0)
        }

        guard numbers.count == 4 else {
            return nil
        }

        return numbers
    }
    
    private func string(from octets: [UInt8]) -> String {

        octets.map(String.init).joined(separator: ".")
    }

    private func isValidSubnetMask(_ mask: [UInt8]) -> Bool {
        let value = mask.reduce(UInt32(0)) { partialResult, octet in
            (partialResult << 8) | UInt32(octet)
        }

        return (0...32).contains { prefix in
            let expected: UInt32 = prefix == 0
                ? 0
                : UInt32.max << (32 - prefix)
            return value == expected
        }
    }
    
    private func networkAddress(ip: [UInt8], mask: [UInt8]) -> [UInt8] {

        zip(ip, mask).map { $0 & $1 }

    }
    
    private func broadcastAddress(network: [UInt8], mask: [UInt8]) -> [UInt8] {

        zip(network, mask).map { networkByte, maskByte in
            networkByte | ~maskByte
        }

    }
    
    private func firstHost(from network: [UInt8]) -> [UInt8] {

        var host = network
        host[3] += 1
        return host

    }
    
    private func lastHost(from broadcast: [UInt8]) -> [UInt8] {

        var host = broadcast
        host[3] -= 1
        return host

    }
    
    private func prefixLength(from mask: [UInt8]) -> Int {

        mask.reduce(0) { total, octet in
            total + octet.nonzeroBitCount
        }
    }
    
    private func hostCount(prefix: Int) -> Int {

        let hostBits = 32 - prefix
        return (1 << hostBits) - 2
    }
}
