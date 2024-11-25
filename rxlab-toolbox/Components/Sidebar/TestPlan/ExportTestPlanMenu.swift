//
//  ExportTestPlanMenu.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/26/24.
//

import Common
import SwiftUI
import TestKit

struct ExportTestPlanMenu: View {
    @Environment(AlertManager.self) var alertManager
    let plan: TestPlan

    var body: some View {
        ForEach(TestPlan.SupportedExportedType.allCases, id: \.self) {
            type in
            Button {
                Task {
                    await save(type: type)
                }
            } label: {
                Text("Export to \(type.description)")
            }
        }
    }

    private func save(type: TestPlan.SupportedExportedType) async {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [
            type.utType
        ]
        panel.nameFieldStringValue = "\(plan.name.toUnderScroreCase()).\(type.fileExtension)"
        if panel.runModal() == NSApplication.ModalResponse.OK {
            // Save the file
            do {
                guard let data = try plan.generate(to: type).data(using: .utf8) else {
                    alertManager.showAlert(message: "Error encoding data")
                    return
                }
                try data.write(to: panel.url!, options: .atomic)
            } catch let err as LocalizedError {
                alertManager.showAlert(err)
            } catch {
                alertManager.showAlert(message: "Error saving file: \(error.localizedDescription)")
                logger.error("Error saving file: \(error)")
            }
        }
    }
}
