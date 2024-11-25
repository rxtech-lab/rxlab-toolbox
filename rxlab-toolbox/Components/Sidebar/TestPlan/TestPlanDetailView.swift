//
//  TestPlanDetailView.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/25/24.
//

import Common
import SwiftUI
import TestKit
import UniformTypeIdentifiers

struct TestPlanDetailView: View {
    let plan: TestPlan
    @Binding var document: RxToolboxDocument
    @Environment(AlertManager.self) var alertManager

    var body: some View {
        TestPlanFlowView(testPlan: plan) {
            newPlan in
            document.testPlans = document.testPlans.map { $0.id == newPlan.id ? newPlan : $0 }
        }
        .navigationTitle(plan.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    ExportTestPlanMenu(plan: plan)
                } label: {
                    Label("Export", systemImage: "square.and.arrow.up")
                }
                .menuIndicator(.hidden)
            }
        }
    }
}
