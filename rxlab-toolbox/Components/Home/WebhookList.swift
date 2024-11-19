//
//  WebhookList.swift
//  mock-telegram-app
//
//  Created by Qiwei Li on 11/14/24.
//

import MockTelegramKit
import SwiftUI

struct WebhookList: View {
    @Environment(MockTelegramKitManager.self) var mockTelegramKitManager

    let onDelete: (Webhook) async -> Void

    var body: some View {
        ForEach(mockTelegramKitManager.webhooks) { webhook in
            NavigationLink(value: NavigationPath.webhook(webhook)) {
                VStack(alignment: .leading) {
                    Text("Chatroom: \(webhook.chatroomId)")
                        .font(.headline)
                    Text(webhook.url.absoluteString)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
                .contextMenu {
                    Button("Delete Webhook") {
                        Task {
                            await ChatManager.shared.deleteWebhook(id: webhook.id)
                            await onDelete(webhook)
                        }
                    }
                }
            }
        }
    }
}
