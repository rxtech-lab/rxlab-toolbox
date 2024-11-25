//
//  Generator.swift
//  TestKit
//
//  Created by Qiwei Li on 11/25/24.
//

import Testing
@testable import TestKit

@Test func testStepContext() async throws {
    let plan = TestPlan(name: "Simple test")
        .addStep(.textInput("Hello world"))
        .addStep(.buttonClick(.init(buttonText: "Plus", messageId: 1)))
        .addStep(.group(.init(messageId: 1).addChild(.expectMessageText(.init(messageId: 1, text: .contains("Hello")))).addChild(.expectMessageCount(.init(count: .equals(1))))))

    let steps = plan.steps.map(StepContext.init)
    #expect(steps.count == 3, "should have 3 steps")
    #expect(steps[0].isTextInput, "first step should be text input")
    #expect(steps[1].isButtonClick, "second step should be button click")
    #expect(steps[2].isGroup, "third step should be group")
    #expect(steps[2].children.count == 2, "group should have 2 children")

    #expect(steps[2].children[0].isExpectMessageText, "should have expect message text")
    #expect(steps[2].children[1].isExpectMessageCount, "should have expect message count")
}

@Test func testGenerateJestCode() throws {
    let plan = TestPlan(name: "Simple test")
        .addStep(.textInput("Hello world"))
        .addStep(.buttonClick(.init(buttonText: "Plus", messageId: 1)))
        .addStep(.group(.init(messageId: 1).addChild(.expectMessageText(.init(messageId: 1, text: .contains("Hello")))).addChild(.expectMessageCount(.init(count: .equals(1))))))

    let result = try plan.generate(to: .jest)
    #expect(result.contains("describe(\"Simple test\", () => {"), "test should start with test name")
    #expect(result.contains("await api.chatroom.clickOnMessageInChatroom("), "should click on message")
    #expect(result.contains("await api.chatroom.sendMessageToChatroom(chatroomId, {"), "should contain send message")
    #expect(result.contains("toContain"), "should contain expect message text")
    #expect(result.contains("toBe"), "should contain expect message count")
}
