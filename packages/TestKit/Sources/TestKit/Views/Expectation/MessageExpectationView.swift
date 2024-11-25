//
//  ListExpectationView.swift
//  TestKit
//
//  Created by Qiwei Li on 11/24/24.
//

import SwiftUI

private enum Operation: String, CaseIterable {
    case equal = "equals to"
    case greaterThan = "greater than"
    case lessThan = "less than"
    case notEqual = "not equals to"
}

typealias OnMessageExpectationChange = (MessageExpectationOperator) -> Void

struct MessageExpectationView: View {
    let expectation: MessageExpectationOperator
    let onChange: OnMessageExpectationChange?

    @State private var size: Int = 0
    @State private var operation: Operation = .equal

    init(expectation: MessageExpectationOperator, onChange: OnMessageExpectationChange? = nil) {
        switch expectation {
        case .equals(let size):
            self._size = State(initialValue: size)
            _operation = State(initialValue: .equal)
        case .greaterThan(let size):
            self._size = State(initialValue: size)
            _operation = State(initialValue: .greaterThan)
        case .lessThan(let size):
            self._size = State(initialValue: size)
            _operation = State(initialValue: .lessThan)
        case .notEquals(let size):
            self._size = State(initialValue: size)
            _operation = State(initialValue: .notEqual)
        }
        self.expectation = expectation
        self.onChange = onChange
    }

    var body: some View {
        HStack {
            Text("Expect")
                .fontWeight(.bold)
            Picker("Messages size", selection: $operation) {
                ForEach(Operation.allCases, id: \.self) {
                    Text($0.rawValue)
                        .frame(minWidth: 100)
                        .tag($0)
                }
            }
            TextField("", value: $size, formatter: NumberFormatter())
                .frame(maxWidth: 50)
        }
    }

    private func updateExpectation() {
        switch operation {
        case .equal:
            onChange?(.equals(size))
        case .greaterThan:
            onChange?(.greaterThan(size))
        case .lessThan:
            onChange?(.lessThan(size))
        case .notEqual:
            onChange?(.notEquals(size))
        }
    }
}

#Preview {
    Form {
        MessageExpectationView(expectation: .equals(10))
    }
    .frame(width: 400)
    .padding()
}
