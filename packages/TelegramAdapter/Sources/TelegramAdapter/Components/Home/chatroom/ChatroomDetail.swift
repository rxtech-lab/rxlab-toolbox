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
    @Environment(AlertManager.self) var alertManager
    @Environment(TelegramServerManager.self) var mockServerManager

    var body: some View {
        ChatView(
            chatroom: chatroom, messages: messages,
            onSendMessage: { message in
                if !mockServerManager.isServerRunning {
                    alertManager.showAlert(message: "Server is not running")
                    return
                }
                _ = await ChatManager.shared.sendMessage(
                    chatroomId: chatroom.id, messageRequest: .init(type: .text, content: message))
            }
        )
        .frame(minWidth: 500)
        .task {
            self.messages = await ChatManager.shared.getMessagesByChatroom(chatroomId: chatroom.id)
            for await (chatroomId, _) in await ChatManager.shared.messageListeners.values {
                if chatroomId != chatroom.id {
                    continue
                }
                messages = await ChatManager.shared.getMessagesByChatroom(chatroomId: chatroom.id)
            }
        }
    }
}

//
// #Preview {
//    ChatroomDetail()
// }
