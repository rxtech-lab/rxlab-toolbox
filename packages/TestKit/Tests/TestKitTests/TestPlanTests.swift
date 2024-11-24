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
        .addStep(.buttonClick(.init(buttonText: "Hello", messageId: 1)))

    let encodingVersion = try JSONEncoder().encode(testplan)
    let decodingVersion = try JSONDecoder().decode(TestPlan.self, from: encodingVersion)

    #expect(testplan == decodingVersion, "Decoding and encoding should be the same")
}

@Test func testAddingSteps() async throws {
    let testplan = TestPlan(name: "Hello World")
        .addStep(.textInput("Hello world"))
        .addStep(.buttonClick(.init(buttonText: "Hello", messageId: 1)))
        .addStep(.group(.init(children: [
            .expectMessageText(.init(messageId: 0, text: .equals("Hello world"))),
            .expectMessageText(.init(messageId: 1, text: .equals("Hello")))
        ])))

    let firstStep = testplan.steps[0].rawValue as! TextInputStep
    #expect(firstStep.text == "Hello world", "Text input step should have the correct text")

    let secondStep = testplan.steps[1].rawValue as! ButtonClickStep
    #expect(secondStep.buttonText == "Hello", "Button click step should have the correct button text")

    let thirdStep = testplan.steps[2].rawValue as! GroupStep
    #expect(thirdStep.children.count == 2, "Group step should have 2 children")
}

@Test func updateStep() async throws {
    let groupUUID = UUID()
    let messageUUID = UUID()
    let testplan = TestPlan(name: "Hello World")
        .addStep(.textInput("Hello world"))
        .addStep(.buttonClick(.init(buttonText: "Hello", messageId: 1)))
        .addStep(.group(.init(id: groupUUID, children: [
            .expectMessageText(.init(id: messageUUID, messageId: 0, text: .equals("Hello world"))),
            .expectMessageText(.init(messageId: 1, text: .equals("Hello")))
        ])))

    let updatedPlan = testplan.updateStep(.expectMessageText(.init(messageId: 1, text: .equals("Goodbye"))), at: messageUUID)
    let group = updatedPlan.steps[2].rawValue as! GroupStep
    #expect((group.children[0].rawValue as! ExpectMessageTextStep).text == .equals("Goodbye"), "should update the correct step")
}

@Test func testDeletingSteps() async throws {
    // Create UUIDs for steps we want to track
    let textInputUUID = UUID()
    let buttonClickUUID = UUID()
    let groupUUID = UUID()
    let messageTextUUID = UUID()

    // Create a test plan with multiple steps
    let testplan = TestPlan(name: "Hello World")
        .addStep(.textInput(.init(id: textInputUUID, text: "Hello world")))
        .addStep(.buttonClick(.init(id: buttonClickUUID, buttonText: "Hello", messageId: 1)))
        .addStep(.group(.init(id: groupUUID, children: [
            .expectMessageText(.init(id: messageTextUUID, messageId: 0, text: .equals("Hello world"))),
            .expectMessageText(.init(messageId: 1, text: .equals("Hello")))
        ])))

    // Test deleting a root-level step
    let planWithoutTextInput = testplan.deleteStep(at: textInputUUID)
    #expect(planWithoutTextInput.steps.count == 2, "Should have one less step after deletion")
    #expect(planWithoutTextInput.steps.contains(where: { $0.rawValue.id == textInputUUID }) == false,
            "Deleted step should not be present")

    // Test deleting a group step
    let planWithoutGroup = testplan.deleteStep(at: groupUUID)
    #expect(planWithoutGroup.steps.count == 2, "Should have one less step after deleting group")
    #expect(planWithoutGroup.steps.contains(where: { $0.rawValue.id == groupUUID }) == false,
            "Deleted group should not be present")

    // Test deleting a non-existent step (should not modify the plan)
    let planWithNonExistentDeletion = testplan.deleteStep(at: UUID())
    #expect(planWithNonExistentDeletion.steps.count == testplan.steps.count,
            "Deleting non-existent step should not modify the plan")
}
