//
//  mock_telegram_appApp.swift
//  mock-telegram-app
//
//  Created by Qiwei Li on 11/14/24.
//

import Common
import Logging
import SwiftData
import SwiftUI
import TelegramAdapter
import TestKit

let logger = Logger(label: "rxlab.rxlab-toolbox")

@main
struct RxlabToolbox: App {
    @State private var serverManager = TelegramServerManager()
    @State private var sheetManager = SheetManager()
    @State private var alertManager = AlertManager()
    @State private var mockTelegramKitManager = MockTelegramKitManager()
    @State private var confirmManager = ConfirmManager()
    @State private var adapterManager = AdapterManager()
    @State private var testManager = TestkitManager()

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
        .environment(testManager)
        .environment(adapterManager)

        WindowGroup(id: "welcome-window") {
            WelcomeScreen()
        }
        // hide title bar
        .windowStyle(.hiddenTitleBar)
        .defaultLaunchBehavior(.presented)
    }
}
