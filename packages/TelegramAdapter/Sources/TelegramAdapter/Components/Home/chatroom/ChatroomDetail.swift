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

struct ChatroomDetail: View {
    let chatroom: Chatroom
    @State var messages: [Message] = []
    @Environment(ConfirmManager.self) var confirmManager
    @Environment(TelegramServerManager.self) var mockServerManager
    @AppStorage("webhookHost") private var host = "0.0.0.0"
    @AppStorage("webhookPort") private var port = 8080

    var body: some View {
        ChatView(
            chatroom: chatroom, messages: messages,
            onSendMessage: { message in
                if !mockServerManager.isServerRunning {
                    confirmManager.showConfirmation(title: "Server is not running", message: "Do you want to start the server?") {
                        mockServerManager.startServer(host: host, port: port)
                        _ = await ChatManager.shared.sendMessage(
                            chatroomId: chatroom.id, messageRequest: .init(type: .text, content: message)
                        )
                    }
                    return
                }
                _ = await ChatManager.shared.sendMessage(
                    chatroomId: chatroom.id, messageRequest: .init(type: .text, content: message)
                )
            }
        )
        .frame(minWidth: 500)
        .task {
            self.messages = await ChatManager.shared.getMessagesByChatroom(chatroomId: chatroom.id)
            for await _ in await ChatManager.shared.messageListeners.values {
                messages = await ChatManager.shared.getMessagesByChatroom(chatroomId: chatroom.id)
            }
        }
    }
}

//
// #Preview {
//    ChatroomDetail()
// }
