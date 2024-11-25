import SwiftUI

typealias OnDelete = (TestStep) -> Void

typealias OnNodeSelected = (GroupStep) -> Void

public struct TestPlanFlowView: View {
    let testPlan: TestPlan
    let onChange: (TestPlan) -> Void
    
    @State private var selectedNode: TestStep?
    @State private var showUpdatePopover = false
    @State private var nodeToUpdate: GroupStep?
    
    public init(testPlan: TestPlan, onChange: @escaping (TestPlan) -> Void) {
        self.testPlan = testPlan
        self.onChange = onChange
    }
    
    public var body: some View {
        ScrollView([.vertical]) {
            LazyVStack(alignment: .center, spacing: 0) {
                ForEach(Array(testPlan.steps.enumerated()), id: \.element.rawValue.id) { index, step in
                    VStack(spacing: 0) {
                        TestPlanNodeView(
                            step: step,
                            onNodeSelected: handleNodeSelection,
                            onDelete: handleDeleteNode
                        )
                        
                        if index < testPlan.steps.count - 1 {
                            ConnectionLineView()
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .popover(isPresented: $showUpdatePopover, arrowEdge: .trailing) {
            if let node = nodeToUpdate {
                GroupView(
                    messageId: node.messageId,
                    expectations: convertTestStepToExpectations(groupStep: node)
                ) { expectations in
                    handleExpectationUpdate(expectations: expectations)
                }
                .padding()
                .frame(minWidth: 400, minHeight: 300)
            }
        }
    }

    private func handleNodeSelection(step: GroupStep) {
        nodeToUpdate = step
        showUpdatePopover = true
    }
    
    private func handleDeleteNode(step: TestStep) {
        let updatedPlan = testPlan.deleteStep(at: step.rawValue.id)
        onChange(updatedPlan)
    }
    
    private func convertTestStepToExpectations(groupStep: GroupStep) -> [ExpectionSelection] {
        return groupStep.children.map { step in
            switch step {
            case .expectMessageCount(let step):
                return .messages(expectation: step.count)
            case .expectMessageText(let step):
                return .text(messageId: step.messageId, expectation: step.text)
            default:
                return nil
            }
        }.compactMap { $0 }
    }
    
    private func handleExpectationUpdate(expectations: [ExpectionSelection]) {
        guard let nodeToUpdate = nodeToUpdate else { return }
        let newStep: TestStep = .group(GroupStep(
            name: nodeToUpdate.name,
            messageId: nodeToUpdate.messageId,
            children: expectations.map { selection in
                switch selection {
                case .messages(let expectation):
                    return .expectMessageCount(ExpectMessageCountStep(count: expectation))
                case .text(let messageId, let expectation):
                    return .expectMessageText(ExpectMessageTextStep(messageId: messageId, text: expectation))
                }
            }
        ))
        
        let updatedPlan = testPlan.updateStep(newStep, at: nodeToUpdate.id)
        onChange(updatedPlan)
    }
}

struct TestPlanNodeView: View {
    let step: TestStep
    let onNodeSelected: OnNodeSelected
    let onDelete: OnDelete?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            nodeContent
        }
        .frame(minWidth: 800)
    }
    
    private var nodeContent: some View {
        HStack {
            Spacer()
            NodeContentView(step: step, onNodeSelected: onNodeSelected, onDelete: onDelete)
                .contextMenu {
                    if canUpdate {
                        Button("Update") {
                            if case .group(let groupStep) = step {
                                onNodeSelected(groupStep)
                            }
                        }
                    }
                    if let onDelete = onDelete {
                        Button("Delete", role: .destructive) {
                            onDelete(step)
                        }
                    }
                }
            Spacer()
        }
    }
    
    private var canUpdate: Bool {
        switch step {
        case .group:
            return true
        default:
            return false
        }
    }
    
    private func getMessageId() -> Int? {
        switch step {
        case .expectMessageText(let step):
            return step.messageId
        case .buttonClick(let step):
            return step.messageId
        default:
            return nil
        }
    }
}

struct NodeContentView: View {
    let step: TestStep
    let onNodeSelected: OnNodeSelected
    let onDelete: OnDelete?
    
    var body: some View {
        if case .group(let groupStep) = step {
            VStack {
                Text(nodeText)
                ForEach(groupStep.children, id: \.rawValue.id) { childStep in
                    TestPlanNodeView(
                        step: childStep,
                        onNodeSelected: onNodeSelected,
                        onDelete: nil
                    )
                }
            }
            .padding()
            .frame(maxWidth: 400)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(backgroundColor, lineWidth: 1)
            )
        } else {
            Text(nodeText)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(backgroundColor.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(backgroundColor, lineWidth: 1)
                )
        }
    }
    
    private var nodeText: String {
        switch step {
        case .buttonClick(let step):
            return "🔘 Click: \(step.buttonText)"
        case .textInput(let step):
            return "⌨️ Input: \(step.text)"
        case .expectMessageText(let step):
            return "📝 Expect Text (#\(step.messageId)): \(step.text.rawValue)"
        case .expectMessageCount(let step):
            return "🔢 Expect Count: \(step.count.rawValue)"
        case .group(let step):
            return "📁 \(step.name ?? "Group")"
        }
    }
    
    private var backgroundColor: Color {
        switch step {
        case .buttonClick:
            return .blue
        case .textInput:
            return .green
        case .expectMessageText:
            return .orange
        case .expectMessageCount:
            return .purple
        case .group:
            return .gray
        }
    }
}

// Helper function to find a step by ID
func findStep(id: UUID, in steps: [TestStep]) -> TestStep? {
    for step in steps {
        if step.rawValue.id == id {
            return step
        }
        if case .group(let groupStep) = step {
            if let found = findStep(id: id, in: groupStep.children) {
                return found
            }
        }
    }
    return nil
}

struct ConnectionLineView: View {
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 2, height: 20)
                .padding(.leading, 16) // Align with node content
        }
    }
}

#Preview {
    TestPlanFlowView(testPlan:
        .init(name: "Hello")
            .addStep(.textInput("Hello"))
            .addStep(.buttonClick(.init(buttonText: "Tap", messageId: 1)))
            .addStep(.expectMessageText(.init(messageId: 1, text: .contains("Hello"))))
            .addStep(.group(.init(messageId: 1).addChild(.expectMessageText(.init(messageId: 1, text: .contains("a")))).addChild(.expectMessageCount(.init(count: .lessThan(2)))))
            )
    ) { _ in
    }
    .frame(width: 500)
}
