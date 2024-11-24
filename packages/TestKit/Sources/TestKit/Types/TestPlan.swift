//
//  TestPlan.swift
//  TestKit
//
//  Created by Qiwei Li on 11/24/24.
//
import Foundation

public struct TestPlan: Codable, Identifiable, Equatable {
    public var id = UUID()
    public var name: String
    public var createdAt: Date = .init()
    public private(set) var child: TestStep?

    public init(id: UUID = UUID(), name: String, createdAt: Date = .now) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.child = nil
    }

    init(id: UUID = UUID(), name: String, createdAt: Date = .now, child: TestStep?) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.child = child
    }

    public func addStep(_ step: TestStep) -> Self {
        if let child = child {
            return TestPlan(id: id, name: name, createdAt: createdAt, child: child.addStep(step))
        }
        return TestPlan(id: id, name: name, createdAt: createdAt, child: step)
    }
}

/**
 TestStep represents different types of test actions that can be performed.
 Each case corresponds to a specific type of user interaction or validation.

 Examples:
 ```swift
 // Button click with validation
 let clickStep: TestStep = .buttonClick(ButtonClickStep(
     buttonText: "Submit",
     messageIndex: "response-1",
     children: [
         .expectMessageText(ExpectMessageTextStep(
             messageIndex: "response-1",
             text: .contains("Success"),
             children: []
         ))
     ]
 ))

 // Text input with subsequent validation
 let inputStep: TestStep = .textInput(TextInputStep(
     text: "Hello, world!",
     children: [
         .expectMessageCount(ExpectMessageCountStep(
             count: .greaterThan(2),
             children: []
         ))
     ]
 ))
 ```
 */
public enum TestStep: Codable, Hashable {
    case buttonClick(ButtonClickStep)
    case textInput(TextInputStep)
    case expectMessageText(ExpectMessageTextStep)
    case expectMessageCount(ExpectMessageCountStep)
    case group(GroupStep)

    func addStep(_ step: TestStep) -> Self {
        switch self {
        case .buttonClick(let buttonClick):
            return .buttonClick(buttonClick.addStep(step))
        case .textInput(let textInput):
            return .textInput(textInput.addStep(step))
        case .expectMessageText(let expectMessageText):
            let newExpectMessageText = expectMessageText.addStep(step)
            return .expectMessageText(newExpectMessageText)
        case .expectMessageCount(let expectMessageCount):
            return .expectMessageCount(expectMessageCount.addStep(step))
        case .group(let group):
            return .group(group.addStep(step))
        }
    }

    var rawValue: any StepProtocol {
        switch self {
        case .buttonClick(let step):
            return step
        case .textInput(let step):
            return step
        case .expectMessageText(let step):
            return step
        case .expectMessageCount(let step):
            return step
        case .group(let step):
            return step
        }
    }
}

// MARK: Button Click

/**
 ButtonClickStep simulates a user clicking a button in the UI.
 It can target a specific button by its text and optionally reference a specific message
 for validation purposes.

 Examples:
 ```swift
 // Simple button click
 let simpleClick = ButtonClickStep(
     buttonText: "Submit",
     children: []
 )

 // Button click with message reference and validation
 let complexClick = ButtonClickStep(
     buttonText: "Generate",
     messageIndex: "gen-response",
     children: [
         .expectMessageText(ExpectMessageTextStep(
             messageIndex: "gen-response",
             text: .contains("Generated successfully"),
             children: []
         ))
     ]
 )
 ```
 */
public struct ButtonClickStep: StepProtocol {
    public var id = UUID()
    public var buttonText: String
    public var messageIndex: Int
    public private(set) var children: [TestStep]

    public init(id: UUID = UUID(), buttonText: String, messageIndex: Int) {
        self.id = id
        self.buttonText = buttonText
        self.messageIndex = messageIndex
        self.children = []
    }

    init(id: UUID = UUID(), buttonText: String, messageIndex: Int, children: [TestStep]) {
        self.id = id
        self.buttonText = buttonText
        self.messageIndex = messageIndex
        self.children = children
    }

    public func addStep(_ step: TestStep) -> ButtonClickStep {
        if let firstChild = children.first {
            let newFirstChild = firstChild.addStep(step)
            return ButtonClickStep(id: id, buttonText: buttonText, messageIndex: messageIndex, children: [newFirstChild])
        }

        return ButtonClickStep(id: id, buttonText: buttonText, messageIndex: messageIndex, children: [step])
    }
}

// MARK: - Text Input and Validation

/**
 TextInputStep represents a user entering text into an input field.
 This step is commonly used for simulating form filling or chat message sending.

 Examples:
 ```swift
 // Simple text input
 let simpleInput = TextInputStep(
     text: "Hello, world!",
     children: []
 )

 // Text input with validation
 let inputWithValidation = TextInputStep(
     text: "Query about pricing",
     children: [
         .expectMessageText(ExpectMessageTextStep(
             messageIndex: "response-1",
             text: .contains("pricing"),
             children: []
         )),
         .expectMessageCount(ExpectMessageCountStep(
             count: .equals(1),
             children: []
         ))
     ]
 )
 ```
 */
public struct TextInputStep: StepProtocol {
    public var id = UUID()
    public var text: String
    public private(set) var children: [TestStep]

    public init(id: UUID = UUID(), text: String) {
        self.id = id
        self.text = text
        self.children = []
    }

    init(id: UUID = UUID(), text: String, children: [TestStep]) {
        self.id = id
        self.text = text
        self.children = children
    }

    public func addStep(_ step: TestStep) -> TextInputStep {
        if let firstChild = children.first {
            let newFirstChild = firstChild.addStep(step)
            return TextInputStep(id: id, text: text, children: [newFirstChild])
        }

        return TextInputStep(id: id, text: text, children: [step])
    }
}

extension TextInputStep: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(text: value)
    }
}

// MARK: - Message Validation

/**
 ExpectMessageTextStep validates the content of a specific message.
 It supports various text comparison operations like equality, containment, and non-containment.

 Examples:
 ```swift
 // Exact text matching
 let exactMatch = ExpectMessageTextStep(
     messageIndex: "response-1",
     text: .equals("Expected exact response"),
     children: []
 )

 // Partial text matching
 let containsMatch = ExpectMessageTextStep(
     messageIndex: "response-2",
     text: .contains("error"),
     children: []
 )

 // Negative text matching
 let notContainsMatch = ExpectMessageTextStep(
     messageIndex: "response-3",
     text: .notContains("failure"),
     children: []
 )
 ```
 */
public struct ExpectMessageTextStep: StepProtocol {
    public var id = UUID()
    public var messageIndex: Int
    public var text: TextExpectationOperator
    public private(set) var children: [TestStep]

    public init(id: UUID = UUID(), messageIndex: Int, text: TextExpectationOperator) {
        self.id = id
        self.messageIndex = messageIndex
        self.text = text
        self.children = []
    }

    init(id: UUID = UUID(), messageIndex: Int, text: TextExpectationOperator, children: [TestStep]) {
        self.id = id
        self.messageIndex = messageIndex
        self.text = text
        self.children = children
    }

    public func addStep(_ step: TestStep) -> ExpectMessageTextStep {
        if let firstChild = children.first {
            let newFirstChild = firstChild.addStep(step)
            return ExpectMessageTextStep(id: id, messageIndex: messageIndex, text: text, children: [newFirstChild])
        }

        return ExpectMessageTextStep(id: id, messageIndex: messageIndex, text: text, children: [step])
    }
}

// MARK: - Message Count Validation

/**
 ExpectMessageCountStep validates the number of messages present.
 It supports various numerical comparisons like equality, greater than, and less than.

 Examples:
 ```swift
 // Exact count matching
 let exactCount = ExpectMessageCountStep(
     count: .equals(3),
     children: []
 )

 // Minimum count validation
 let minimumCount = ExpectMessageCountStep(
     count: .greaterThan(5),
     children: []
 )

 // Maximum count validation
 let maximumCount = ExpectMessageCountStep(
     count: .lessThan(10),
     children: []
 )

 // Complex validation chain
 let complexCount = ExpectMessageCountStep(
     count: .greaterThan(2),
     children: [
         .expectMessageText(ExpectMessageTextStep(
             messageIndex: "last",
             text: .contains("completion"),
             children: []
         ))
     ]
 )
 ```
 */
public struct ExpectMessageCountStep: StepProtocol {
    public var id = UUID()
    public var count: MessageExpectationOperator
    public private(set) var children: [TestStep]

    public init(id: UUID = UUID(), count: MessageExpectationOperator) {
        self.id = id
        self.count = count
        self.children = []
    }

    init(id: UUID = UUID(), count: MessageExpectationOperator, children: [TestStep]) {
        self.id = id
        self.count = count
        self.children = children
    }

    public func addStep(_ step: TestStep) -> ExpectMessageCountStep {
        if let firstChild = children.first {
            let newFirstChild = firstChild.addStep(step)
            return ExpectMessageCountStep(id: id, count: count, children: [newFirstChild])
        }

        return ExpectMessageCountStep(id: id, count: count, children: [step])
    }
}

/**
 Group one or more steps together for better organization and readability.
 */
public struct GroupStep: StepProtocol {
    public var id: UUID
    public var name: String?
    public private(set) var children: [TestStep]

    public init(id: UUID = .init(), name: String? = nil, children: [TestStep]? = nil) {
        self.id = id
        self.name = name
        self.children = children ?? []
    }

    public func addChild(_ step: TestStep) -> GroupStep {
        GroupStep(id: id, name: name, children: children + [step])
    }

    public func addStep(_ step: TestStep) -> GroupStep {
        if let firstChild = children.first {
            let newFirstChild = firstChild.addStep(step)
            return GroupStep(id: id, name: name, children: [newFirstChild])
        }

        return GroupStep(id: id, name: name, children: [step])
    }
}
