//
//  GroupView.swift
//  TestKit
//
//  Created by Qiwei Li on 11/24/24.
//

import SwiftUI

enum ExpectionSelection: Identifiable, Hashable {
    var id: String {
        rawValue
    }

    case text(messageId: Int, expectation: TextExpectationOperator)
    case messages(expectation: MessageExpectationOperator)

    var rawValue: String {
        switch self {
        case .text:
            return "Message Content"
        case .messages:
            return "Total Messages Count"
        }
    }

    static func allCases(messageId: Int) -> [ExpectionSelection] {
        return [
            .text(messageId: messageId, expectation: .contains("")),
            .messages(expectation: .equals(0))
        ]
    }
}

struct GroupView: View {
    let messageId: Int
    let confirmAction: ([ExpectionSelection]) -> Void
    @State private var expectations: [ExpectionSelection] = []
    @State private var showAddExpectation = false

    @Environment(\.dismiss) var dismiss

    init(messageId: Int, confirmAction: @escaping ([ExpectionSelection]) -> Void) {
        self.messageId = messageId
        self.confirmAction = confirmAction
    }

    init(messageId: Int, expectations: [ExpectionSelection], confirmAction: @escaping ([ExpectionSelection]) -> Void) {
        self.messageId = messageId
        self.confirmAction = confirmAction
        self._expectations = State(initialValue: expectations)
    }

    var body: some View {
        VStack {
            HStack {
                Text("Add Expectations")
                    .font(.headline)
                Spacer()
                Menu {
                    ForEach(ExpectionSelection.allCases(messageId: messageId)) { expectation in
                        Button {
                            expectations.append(expectation)
                        } label: {
                            Label(expectation.rawValue, systemImage: "plus")
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                }
                .frame(width: 25, height: 25)
                .menuIndicator(.hidden)
                .menuStyle(.borderedButton)
            }
            Divider()
            ScrollView {
                ForEach(expectations) { expectation in
                    buildExpectationView(expectation: expectation)
                }
            }
            .frame(minHeight: 200)
            Divider()
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                Button {
                    confirmAction(expectations)
                    dismiss()
                } label: {
                    Text("Confirm")
                }
            }
        }
    }

    @ViewBuilder private func buildExpectationView(expectation: ExpectionSelection) -> some View {
        HStack {
            switch expectation {
            case .text(let messageId, let textOperator):
                TextExpectationView(messageId: messageId, expection: textOperator) {
                    change in
                    if let index = expectations.firstIndex(of: expectation) {
                        expectations[index] = .text(messageId: messageId, expectation: change)
                    }
                }
            case .messages(let messageOperator):
                MessageExpectationView(expectation: messageOperator) {
                    change in
                    if let index = expectations.firstIndex(of: expectation) {
                        expectations[index] = .messages(expectation: change)
                    }
                }
            }

            Button {
                let index = expectations.firstIndex(of: expectation)
                if let index = index {
                    expectations.remove(at: index)
                }
            } label: {
                Image(systemName: "trash")
            }
        }
    }
}

#Preview {
    GroupView(messageId: 1) { _ in
    }
    .padding()
}
