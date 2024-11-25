//
//  RecordMessageModifier.swift
//  TestKit
//
//  Created by Qiwei Li on 11/24/24.
//

import SwiftUI

/**
  Add a matcher about the message in the current test plan
 */
public struct RecordMessageModifier: ViewModifier {
    @Environment(TestkitManager.self) var testkitManager
    let index: Int
    @State var showPopover: Bool = false

    init(at index: Int) {
        self.index = index
    }

    public func body(content: Content) -> some View {
        Group {
            if !testkitManager.isTesting {
                content
            } else {
                content
                    .contextMenu {
                        Button("\(convertTestPlanToExpectationSelection().count > 0 ? "Update" : "Add") expectation") {
                            self.showPopover.toggle()
                        }
                    }
                    .popover(isPresented: $showPopover, arrowEdge: .trailing) {
                        ScrollView {
                            GroupView(messageId: index, expectations: convertTestPlanToExpectationSelection()) { expectations in
                                addOrUpdateExpectation(selections: expectations)
                            }
                        }
                        .padding()
                        .frame(minWidth: 400, minHeight: 300)
                    }
            }
        }
    }

    // Converts TestPlan steps to ExpectationSelection array
    func convertTestPlanToExpectationSelection() -> [ExpectionSelection] {
        guard let testPlan = testkitManager.testplan, !testPlan.steps.isEmpty else {
            return []
        }

        let targetSteps = findStepsForIndex(index: index, steps: testPlan.steps)
        guard !targetSteps.isEmpty else {
            return []
        }

        return targetSteps.compactMap { step in
            switch step {
            case .expectMessageCount(let expectation):
                return .messages(expectation: expectation.count)
            case .expectMessageText(let expectation):
                return .text(messageId: expectation.messageId, expectation: expectation.text)
            default:
                return nil
            }
        }
    }

    // Converts ExpectationSelection array to a group TestStep
    func convertExpectationSelectionToTestStep(selections: [ExpectionSelection]) -> TestStep {
        let steps: [TestStep] = selections.map { selection in
            switch selection {
            case .messages(let expectation):
                return .expectMessageCount(.init(count: expectation))
            case .text(let messageId, let expectation):
                return .expectMessageText(.init(messageId: messageId, text: expectation))
            }
        }

        return .group(.init(name: "group-\(index)", messageId: index, children: steps))
    }

    // Adds or updates expectations in the TestPlan
    func addOrUpdateExpectation(selections: [ExpectionSelection]) {
        guard let testplan = testkitManager.testplan else {
            return
        }

        let step = convertExpectationSelectionToTestStep(selections: selections)
        let groupId = findGroupIdForIndex(index: index, steps: testplan.steps)

        if let groupId = groupId {
            // Update existing group
            let updated = testplan.updateStep(step, at: groupId)
            testkitManager.testplan = updated
        } else {
            // Add new group
            let updated = testplan.addStep(step)
            testkitManager.testplan = updated
        }
    }
}

public extension View {
    func recordMessage(at index: Int) -> some View {
        modifier(RecordMessageModifier(at: index))
    }
}
