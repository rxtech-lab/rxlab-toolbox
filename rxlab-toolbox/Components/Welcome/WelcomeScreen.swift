//
//  WelcomeScreen.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/19/24.
//

import SwiftData
import SwiftUI

struct AppVersion {
    static var current: String {
        let marketingVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        #if DEBUG
            return "\(marketingVersion) (\(buildNumber))"
        #else
            return marketingVersion
        #endif
    }
}

struct WelcomeScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.newDocument) private var newDocument
    @Environment(\.openDocument) private var openDocument
    @Environment(\.dismissWindow) private var dismissWindow

    var body: some View {
        HStack(spacing: 0) {
            // Left panel
            VStack(alignment: .center, spacing: 20) {
                // Logo
                Image("AppLogo")
                    .resizable()
                    .frame(width: 128, height: 128)
                // App name
                Text(AppStrings.appName.rawValue)
                    .font(.title)
                    .foregroundColor(.primary)
                    .fontWeight(.bold)

                // display current version
                Text("Version: \(AppVersion.current)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                // Options
                VStack(alignment: .leading, spacing: 12) {
                    WelcomeOptionButton(
                        icon: "plus.square",
                        title: "Create New Project...",
                        action: createNewProject
                    )

                    WelcomeOptionButton(
                        icon: "folder",
                        title: "Open Existing Project...",
                        action: openProject
                    )
                }

                Spacer()
            }
            .padding(32)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray).opacity(0.1))
        }
        .frame(minWidth: 400, minHeight: 300)
    }
}

extension WelcomeScreen {
    private func createNewProject() {
        newDocument(contentType: .toolboxDocument)
        dismiss()
    }

    private func openProject() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [.toolboxDocument]

        if panel.runModal() == .OK {
            if let url = panel.url {
                Task {
                    try await openDocument(at: url)
                    dismissWindow(id: "welcome-window")
                }
            }
        }
    }
}
