//
//  WebhookContextMenu.swift
//  mock-telegram-app
//
//  Created by Qiwei Li on 11/14/24.
//

import MockTelegramKit
import SwiftUI

struct WebhookContextMenu: View {
    @Environment(SheetManager.self) var sheetManager
    @Environment(AlertManager.self) var alertManager

    @State private var chatroomId: Int = 0
    @State private var webhookUrl: String = "http://localhost:3000/api/webhook"

    var form: some View {
        Form {
            Text("Add new webhook")
            TextField("Chatroom ID", value: $chatroomId, formatter: NumberFormatter())
            TextField("Webhook URL", text: $webhookUrl)
        }
        .padding()
    }

    var body: some View {
        VStack {
            Button {
                sheetManager.showSheet {
                    form
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    sheetManager.hideSheet()
                                }
                            }

                            ToolbarItem(placement: .confirmationAction) {
                                Button("Save") {
                                    Task {
                                        do {
                                            try await ChatManager.shared.registerWebhook(chatroomId: chatroomId, url: webhookUrl)
                                            sheetManager.hideSheet()
                                        } catch let error as LocalizedError {
                                            sheetManager.hideSheet()
                                            alertManager.showAlert(error)
                                        }
                                    }
                                }
                            }
                        }
                }
            } label: {
                Text("Add new webhook")
            }
        }
    }
}

#Preview {
    WebhookContextMenu()
}
