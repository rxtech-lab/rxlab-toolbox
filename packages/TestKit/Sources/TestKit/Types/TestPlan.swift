import Foundation

/// A test plan that contains a sequence of test steps to be executed.
/// Used to define automated test scenarios for user interactions.
public struct TestPlan: Codable, Identifiable, Equatable, Hashable {
    public var id = UUID()
    public var name: String
    public var createdAt: Date = .init()
    public private(set) var steps: [TestStep]

    public init(id: UUID = UUID(), name: String, createdAt: Date = .now) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.steps = []
    }

    init(id: UUID = UUID(), name: String, createdAt: Date = .now, steps: [TestStep]) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.steps = steps
    }

    public func addStep(_ step: TestStep) -> Self {
        TestPlan(id: id, name: name, createdAt: createdAt, steps: steps + [step])
    }

    public func updateStep(_ step: TestStep, at id: UUID) -> Self {
        let updatedSteps = steps.map { s in
            if s.rawValue.id == id {
                return step
            }
            return s
        }
        return TestPlan(id: self.id, name: name, createdAt: createdAt, steps: updatedSteps)
    }

    public func deleteStep(at id: UUID) -> Self {
        let filteredSteps = steps.filter { $0.rawValue.id != id }
        return TestPlan(id: self.id, name: name, createdAt: createdAt, steps: filteredSteps)
    }
}

/// Represents different types of test actions that can be executed.
/// Each case corresponds to a specific user interaction or validation step.
public enum TestStep: Codable, Hashable {
    case buttonClick(ButtonClickStep)
    case textInput(TextInputStep)
    case expectMessageText(ExpectMessageTextStep)
    case expectMessageCount(ExpectMessageCountStep)
    case group(GroupStep)

    var rawValue: any StepProtocol {
        switch self {
        case .buttonClick(let step): return step
        case .textInput(let step): return step
        case .expectMessageText(let step): return step
        case .expectMessageCount(let step): return step
        case .group(let step): return step
        }
    }
}

/// Simulates a button click interaction in the UI.
/// Can be used to test button-based interactions and their responses.
public struct ButtonClickStep: StepProtocol {
    public var id = UUID()
    public var buttonText: String
    public var messageId: Int

    public init(id: UUID = UUID(), buttonText: String, messageId: Int) {
        self.id = id
        self.buttonText = buttonText
        self.messageId = messageId
    }
}

/// Represents a text input action in the UI.
/// Used for testing form inputs, chat messages, or any text-based interaction.
public struct TextInputStep: StepProtocol {
    public var id = UUID()
    public var text: String

    public init(id: UUID = UUID(), text: String) {
        self.id = id
        self.text = text
    }
}

extension TextInputStep: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(text: value)
    }
}

/// Validates the content of a specific message.
/// Used to verify that responses contain expected text or patterns.
public struct ExpectMessageTextStep: StepProtocol {
    public var id = UUID()
    public var messageId: Int
    public var text: TextExpectationOperator

    public init(id: UUID = UUID(), messageId: Int, text: TextExpectationOperator) {
        self.id = id
        self.messageId = messageId
        self.text = text
    }
}

/// Validates the number of messages in a conversation.
/// Used to ensure the expected number of responses or interactions occurred.
public struct ExpectMessageCountStep: StepProtocol {
    public var id = UUID()
    public var count: MessageExpectationOperator

    public init(id: UUID = UUID(), count: MessageExpectationOperator) {
        self.id = id
        self.count = count
    }
}

/// Groups related test steps together for better organization.
/// Useful for creating logical sections in a test plan.
public struct GroupStep: StepProtocol {
    public var id: UUID
    public var name: String?
    public var messageId: Int
    public private(set) var children: [TestStep]

    public init(id: UUID = .init(), name: String? = nil, messageId: Int, children: [TestStep]? = nil) {
        self.id = id
        self.name = name
        self.messageId = messageId
        self.children = children ?? []
    }

    public func addChild(_ step: TestStep) -> GroupStep {
        GroupStep(id: id, name: name, messageId: messageId, children: children + [step])
    }
}
