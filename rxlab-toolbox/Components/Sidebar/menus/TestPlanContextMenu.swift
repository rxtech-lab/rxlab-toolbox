//
//  TestPlanContextMenu.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/25/24.
//

import Common
import SwiftUI
import TestKit

struct TestPlanContextMenu: View {
    let plan: TestPlan
    @Binding var document: RxToolboxDocument

    @Environment(SheetManager.self) var sheetManager
    @State var name: String = ""
    @Binding var selected: NavigationPath?

    init(plan: TestPlan, document: Binding<RxToolboxDocument>, selected: Binding<NavigationPath?>) {
        self.plan = plan
        _document = document
        _name = State(initialValue: plan.name)
        _selected = selected
    }

    var body: some View {
        Button("Edit Test Plan") {
            sheetManager.showSheet {
                Form {
                    TextField("Name", text: $name)
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            if let index = document.testPlans.firstIndex(of: plan) {
                                document.testPlans[index].name = name
                            }
                            sheetManager.hideSheet()
                        }
                        .disabled(name.isEmpty)
                    }

                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            sheetManager.hideSheet()
                        }
                    }
                }
            }
        }
        Button("Delete Test Plan") {
            if let index = document.testPlans.firstIndex(of: plan) {
                document.testPlans.remove(at: index)
                selected = nil
            }
        }
    }
}
