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
    @State var show: Bool = false

    init(at index: Int) {
        self.index = index
    }

    public func body(content: Content) -> some View {
        let canUpdate = canUpdateOrDelete()
        Group {
            if !testkitManager.isTesting {
                content
            } else {
                content
                    .contextMenu {
                        Button("\(canUpdate ? "Update" : "Add") expectation") {
                            self.show.toggle()
                        }
                        if canUpdate {
                            Button("Remove expectation") {
                                removeExpectation()
                            }
                        }
                    }
                    .popover(isPresented: $show, arrowEdge: .trailing) {
                        ScrollView {
                            if canUpdate {
                                GroupView(messageId: index, expectations: convertTestPlanToExpectationSelection()) { expectations in
                                    addOrUpdateExpectation(selections: expectations)
                                }
                            } else {
                                GroupView(messageId: index) { expectations in
                                    addOrUpdateExpectation(selections: expectations)
                                }
                            }
                        }
                        .padding()
                        .frame(minWidth: 400, minHeight: 300)
                    }
            }
        }
    }

    func removeExpectation() {
        guard let testplan = testkitManager.testplan else {
            return
        }

        guard let step = testplan.steps.last else {
            return
        }
        testkitManager.testplan = testplan.deleteStep(at: step.rawValue.id)
    }

    func canUpdateOrDelete() -> Bool {
        // if testplan is empty
        guard let testplan = testkitManager.testplan else {
            return false
        }
        // check if the last plan is group
        let lastStep = testplan.steps.last
        if case .group = lastStep {
            return true
        }
        return false
    }

    // Converts TestPlan steps to ExpectationSelection array
    func convertTestPlanToExpectationSelection() -> [ExpectionSelection] {
        guard let testPlan = testkitManager.testplan, !testPlan.steps.isEmpty else {
            return []
        }

        guard let lastStep = testPlan.steps.last else {
            return []
        }

        guard case .group(let group) = lastStep else {
            return []
        }

        return group.children.compactMap { step in
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
        let canUpdate = canUpdateOrDelete()

        if canUpdate {
            // Update existing group
            guard let lastStep = testplan.steps.last else {
                return
            }

            guard case .group(let group) = lastStep else {
                return
            }
            let updated = testplan.updateStep(step, at: group.id)
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
