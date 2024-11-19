//
//  CreateChatroomForm.swift
//  mock-telegram-app
//
//  Created by Qiwei Li on 11/18/24.
//

import MockTelegramKit
import SwiftUI

struct CreateChatroomForm: View {
    @Environment(SheetManager.self) var sheetManager
    @Environment(AlertManager.self) var alertManager
    @State private var webhookUrl: String = "http://localhost:3000/api/webhook"

    var body: some View {
        Form {
            Text("Add new chatroom")
            TextField("Webhook URL", text: $webhookUrl)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
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
                            let id = await ChatManager.shared.createChatroom()
                            _ = try await ChatManager.shared.registerWebhook(chatroomId: id, url: webhookUrl)
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
}

#Preview {
    CreateChatroomForm()
}
