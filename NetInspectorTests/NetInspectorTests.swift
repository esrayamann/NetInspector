//
//  NetInspectorTests.swift
//  NetInspectorTests
//

import Testing
@testable import NetInspector

struct NetInspectorTests {

    @Test @MainActor func calculatesAStandardIPv4Subnet() {
        let result = IPCalculatorService().calculate(
            ip: "192.168.1.42",
            subnetMask: "255.255.255.0"
        )

        #expect(result?.networkAddress == "192.168.1.0")
        #expect(result?.broadcastAddress == "192.168.1.255")
        #expect(result?.firstHost == "192.168.1.1")
        #expect(result?.lastHost == "192.168.1.254")
        #expect(result?.hostCount == 254)
    }

    @Test @MainActor func rejectsNonContiguousSubnetMasks() {
        let result = IPCalculatorService().calculate(
            ip: "10.0.0.1",
            subnetMask: "255.0.255.0"
        )

        #expect(result == nil)
    }

    @Test @MainActor func handlesPointToPointAndSingleHostSubnets() {
        let calculator = IPCalculatorService()
        let pointToPoint = calculator.calculate(
            ip: "10.0.0.0",
            subnetMask: "255.255.255.254"
        )
        let singleHost = calculator.calculate(
            ip: "10.0.0.1",
            subnetMask: "255.255.255.255"
        )

        #expect(pointToPoint?.hostCount == 2)
        #expect(pointToPoint?.firstHost == "10.0.0.0")
        #expect(pointToPoint?.lastHost == "10.0.0.1")
        #expect(singleHost?.hostCount == 1)
        #expect(singleHost?.firstHost == "10.0.0.1")
        #expect(singleHost?.lastHost == "10.0.0.1")
    }
}
