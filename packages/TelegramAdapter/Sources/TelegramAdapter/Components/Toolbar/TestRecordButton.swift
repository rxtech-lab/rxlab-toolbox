//
//  SwiftUIView.swift
//  TelegramAdapter
//
//  Created by Qiwei Li on 11/25/24.
//

import SwiftUI
import TestKit

struct TestRecordButton: View {
    @Environment(TestkitManager.self) var testkitManager
    @State var showSavePanel: Bool = false

    var body: some View {
        Button {
            if testkitManager.isTesting {
                testkitManager.stopTesting()
                showSavePanel = true
            } else {
                testkitManager.startTesting()
            }
        } label: {
            if testkitManager.isTesting {
                Label("Stop recording", systemImage: "stop.circle.fill")
                    .foregroundColor(.red)
            } else {
                Label("Start recording", systemImage: "record.circle")
            }
        }
        .sheet(isPresented: $showSavePanel, content: {
            if let testplan = testkitManager.testplan {
                TestPlanSavingForm(testPlan: testplan) { name in
                    testkitManager.save(with: name)
                }
                .padding()
            }

        })
        .help("Record a test")
    }
}

#Preview {
    TestRecordButton()
}
