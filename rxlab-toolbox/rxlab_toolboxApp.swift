//
//  mock_telegram_appApp.swift
//  mock-telegram-app
//
//  Created by Qiwei Li on 11/14/24.
//

import SwiftData
import SwiftUI

@main
struct RxlabToolbox: App {
    @State private var serverManager = ServerManager()
    @State private var sheetManager = SheetManager()
    @State private var alertManager = AlertManager()
    @State private var mockTelegramKitManager = MockTelegramKitManager()
    @State private var confirmManager = ConfirmManager()
    @State private var adapterManager = AdapterManager()

    var body: some Scene {
        DocumentGroup(newDocument: RxToolboxDocument()) { file in
            ContentView(document: file.$document)
        }
        .defaultSize(width: 1000, height: 800)
        .environment(serverManager)
        .environment(sheetManager)
        .environment(alertManager)
        .environment(mockTelegramKitManager)
        .environment(confirmManager)
        .environment(adapterManager)

        WindowGroup(id: "welcome-window") {
            WelcomeScreen()
        }
        // hide title bar
        .windowStyle(.hiddenTitleBar)
        .defaultLaunchBehavior(.presented)
    }
}
