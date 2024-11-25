//
//  TestkitManager.swift
//  TestKit
//
//  Created by Qiwei Li on 11/24/24.
//
import Combine
import SwiftUI

@Observable public final class TestkitManager {
    public internal(set) var testplan: TestPlan?
    public var isTesting: Bool = false
    var currentMessageCount = 0
    public var saveEvent: PassthroughSubject<Void, Never> = .init()

    public init() {
        testplan = TestPlan(name: "New Test Plan")
    }

    public func startTesting() {
        testplan = TestPlan(name: "New Test Plan")
        isTesting = true
    }

    public func stopTesting() {
        isTesting = false
    }

    public func save(with name: String) {
        testplan?.name = name
        saveEvent.send()
    }

    public func recordMessageSend(_ message: String) {
        testplan = testplan?.addStep(.textInput(.init(stringLiteral: message)))
    }
}
