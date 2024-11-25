import Foundation
import UniformTypeIdentifiers

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

public extension UTType {
    // Custom UTType for TypeScript spec files
    static var typeScriptSpec: UTType {
        // Try to create a dynamic type for .spec.ts files
        UTType(tag: "ts", tagClass: .filenameExtension, conformingTo: .sourceCode)!
    }
}

public extension TestPlan {
    enum SupportedExportedType: String, CaseIterable {
        case jest

        public var description: String {
            switch self {
            case .jest: return "Jest (TypeScript)"
            }
        }

        public var utType: UTType {
            switch self {
            case .jest:
                return .typeScriptSpec
            }
        }

        public var fileExtension: String {
            switch self {
            case .jest: return "spec.ts"
            }
        }
    }

    func generate(to supportedExportedType: SupportedExportedType) throws -> String {
        switch supportedExportedType {
        case .jest:
            return try Generator(template: .jestTemplate).generate(with: self)
        }
    }
}

public extension String {
    /**
     Convert a string to under_score_case.
     */
    func toUnderScroreCase() -> String {
        replacingOccurrences(of: " ", with: "_")
            .lowercased()
    }
}
