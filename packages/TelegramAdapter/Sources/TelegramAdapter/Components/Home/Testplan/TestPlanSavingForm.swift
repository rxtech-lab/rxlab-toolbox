//
//  TestPlanSavingForm.swift
//  TelegramAdapter
//
//  Created by Qiwei Li on 11/25/24.
//

import SwiftUI
import TestKit

struct TestPlanSavingForm: View {
    let testPlan: TestPlan
    let onSave: (String) -> Void

    @State private var name: String
    @Environment(\.dismiss) var dismiss

    init(testPlan: TestPlan, onSave: @escaping (String) -> Void) {
        self.testPlan = testPlan
        self.onSave = onSave
        self._name = State(initialValue: testPlan.name)
    }

    var body: some View {
        Form {
            TextField("Name", text: $name)
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    onSave(name)
                    dismiss()
                }
            }

            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    TestPlanSavingForm(testPlan: .init(name: "Some name")) { _ in }
        .padding()
}
