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

    var body: some View {
        Button {
            if testkitManager.isTesting {
                testkitManager.stopTesting()
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
        .help("Record a test")
    }
}

#Preview {
    TestRecordButton()
}
