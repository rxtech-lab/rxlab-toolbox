//
//  TestPlanTests.swift
//  TestKit
//
//  Created by Qiwei Li on 11/24/24.
//

import Foundation
import Testing
@testable import TestKit

@Test func encodingAndDecoding() async throws {
    let testplan = TestPlan(name: "Hello World")
        .addStep(.buttonClick(.init(buttonText: "Hello", messageIndex: 1)))

    let encodingVersion = try JSONEncoder().encode(testplan)
    let decodingVersion = try JSONDecoder().decode(TestPlan.self, from: encodingVersion)

    #expect(testplan == decodingVersion, "Decoding and encoding should be the same")
}

@Test func testAddingSteps() async throws {
    let testplan = TestPlan(name: "Hello World")
        .addStep(.textInput("Hello world"))
        .addStep(.buttonClick(.init(buttonText: "Hello", messageIndex: 1)))
        .addStep(.group(.init(children: [
            .expectMessageText(.init(messageIndex: 0, text: .equals("Hello world"))),
            .expectMessageText(.init(messageIndex: 1, text: .equals("Hello")))
        ])))

    let firstStep = testplan.child?.rawValue as! TextInputStep
    #expect(firstStep.text == "Hello world", "Text input step should have the correct text")

    let secondStep = firstStep.children.first?.rawValue as! ButtonClickStep
    #expect(secondStep.buttonText == "Hello", "Button click step should have the correct button text")

    let thirdStep = secondStep.children.first?.rawValue as! GroupStep
    #expect(thirdStep.children.count == 2, "Group step should have 2 children")
}
