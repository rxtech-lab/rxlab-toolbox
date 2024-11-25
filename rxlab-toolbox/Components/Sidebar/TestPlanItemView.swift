//
//  TestPlanItemView.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/25/24.
//

import SwiftUI
import TestKit

struct TestPlanItemView: View {
    let plan: TestPlan
    @Binding var document: RxToolboxDocument
    @Binding var selected: NavigationPath?

    var body: some View {
        NavigationLink(value: NavigationPath.SideBar(.TestPlan(plan))) {
            Text(plan.name)
        }
        .contextMenu {
            TestPlanContextMenu(plan: plan, document: $document, selected: $selected)
        }
    }
}
