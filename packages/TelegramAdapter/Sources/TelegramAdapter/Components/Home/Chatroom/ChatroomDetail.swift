//
//  ChatroomDetail.swift
//  mock-telegram-app
//
//  Created by Qiwei Li on 11/14/24.
//

import Combine
import Common
import MockTelegramKit
import SwiftUI
import TestKit

struct ChatroomDetail: View {
    let chatroom: Chatroom
    @State var messages: [Message] = []
    @Environment(ConfirmManager.self) var confirmManager
    @Environment(TelegramServerManager.self) var mockServerManager
    @Environment(TestkitManager.self) var testKitManager
    @AppStorage("webhookHost") private var host = "0.0.0.0"
    @AppStorage("webhookPort") private var port = 8080
    @State var currentChatroom: Chatroom
    @State var webhook: Webhook? = nil

    init(chatroom: Chatroom) {
        self.chatroom = chatroom
        self.currentChatroom = chatroom
    }

    var body: some View {
        ZStack {
            ChatView(
                chatroom: chatroom, messages: messages,
                onSendMessage: { message in
                    if !mockServerManager.isServerRunning {
                        confirmManager.showConfirmation(title: "Server is not running", message: "Do you want to start the server?") {
                            mockServerManager.startServer(host: host, port: port)
                            _ = await ChatManager.shared.sendMessage(
                                chatroomId: chatroom.id, messageRequest: .init(type: .text, content: message)
                            )
                            testKitManager.recordMessageSend(message)
                        }
                        return
                    }
                    _ = await ChatManager.shared.sendMessage(
                        chatroomId: chatroom.id, messageRequest: .init(type: .text, content: message)
                    )
                    testKitManager.recordMessageSend(message)
                }
            )
            .contextMenu {
                Button {
                    Task {
                        await ChatManager.shared.reset(chatroomId: chatroom.id)
                    }
                } label: {
                    Label("Clear Messages", systemImage: "trash")
                }
            }
            .recordMessages(messagesCount: messages.count)
            .frame(minWidth: 500)
            .onChange(of: chatroom) { _, newValue in
                currentChatroom = newValue
                Task {
                    messages = await ChatManager.shared.getMessagesByChatroom(chatroomId: newValue.id)
                }
            }
            .task {
                messages = await ChatManager.shared.getMessagesByChatroom(chatroomId: currentChatroom.id)
                await getMessages(chatroom: chatroom)
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        Task {
                            webhook = await ChatManager.shared.getWebhook(chatroomId: currentChatroom.id)
                        }
                    }, label: {
                        Label("Webhook info", systemImage: "info.circle.fill")
                    })
                    .foregroundStyle(.gray)
                    .buttonStyle(.bordered)
                    .popover(item: $webhook, content: { webhook in
                        WebhookDetail(webhook: webhook, showEditButton: false)
                    })
                }
            }
            .padding([.trailing], 8)
            .padding([.bottom], 50)
        }
    }

    func getMessages(chatroom: Chatroom) async {
        for await _ in await ChatManager.shared.messageListeners.values {
            messages = await ChatManager.shared.getMessagesByChatroom(chatroomId: currentChatroom.id)
        }
    }
}

//
// #Preview {
//    ChatroomDetail()
// }
