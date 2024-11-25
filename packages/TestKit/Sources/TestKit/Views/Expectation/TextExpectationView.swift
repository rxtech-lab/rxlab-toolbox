//
//  TextExpectationView.swift
//  TestKit
//
//  Created by Qiwei Li on 11/24/24.
//

import SwiftUI

private enum Operation: String, CaseIterable {
    case equal = "equals to"
    case notEqual = "not equals to"
    case contain = "contains"
    case notContain = "not contains"
}

typealias OnExpectationUpdate = (TextExpectationOperator) -> Void

struct TextExpectationView: View {
    let messageId: Int
    let expection: TextExpectationOperator
    @State private var selectedOperation: Operation = .equal
    @State private var expectedValue: String = ""
    let onExpectationUpdate: OnExpectationUpdate?

    init(messageId: Int, expection: TextExpectationOperator, onExpectationUpdate: OnExpectationUpdate? = nil) {
        self.messageId = messageId
        self.expection = expection
        self.onExpectationUpdate = onExpectationUpdate
        switch expection {
        case .contains(let value):
            _selectedOperation = State(initialValue: .contain)
            _expectedValue = State(initialValue: value)

        case .equals(let value):
            _selectedOperation = State(initialValue: .equal)
            _expectedValue = State(initialValue: value)

        case .notContains(let value):
            _selectedOperation = State(initialValue: .notContain)
            _expectedValue = State(initialValue: value)

        case .notEquals(let value):
            _selectedOperation = State(initialValue: .notEqual)
            _expectedValue = State(initialValue: value)
        }
    }

    var body: some View {
        HStack {
            Text("Expect")
                .bold()
            Picker("content", selection: $selectedOperation) {
                ForEach(Operation.allCases, id: \.self) { operation in
                    Text(operation.rawValue)
                }
            }
            TextField("", text: $expectedValue)
                .help("Expected value")
        }
        .onChange(of: selectedOperation) { _, _ in
            updateExpectation()
        }
        .onChange(of: expectedValue) { _, _ in
            updateExpectation()
        }
    }

    func updateExpectation() {
        switch selectedOperation {
        case .contain:
            onExpectationUpdate?(.contains(expectedValue))
        case .equal:
            onExpectationUpdate?(.equals(expectedValue))
        case .notContain:
            onExpectationUpdate?(.notContains(expectedValue))
        case .notEqual:
            onExpectationUpdate?(.notEquals(expectedValue))
        }
    }
}

#Preview {
    Form {
        TextExpectationView(messageId: 1, expection: .contains("A"))
            .padding()
    }
}
