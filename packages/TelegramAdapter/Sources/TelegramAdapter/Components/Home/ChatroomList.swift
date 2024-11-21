//
//  ChatroomList.swift
//  mock-telegram-app
//
//  Created by Qiwei Li on 11/14/24.
//

import SwiftUI

struct ChatroomList: View {
    @Environment(MockTelegramKitManager.self) var mockTelegramKitManager

    let onDelete: (Chatroom) async -> Void

    var body: some View {
        ForEach(mockTelegramKitManager.chatroom.sorted { c1, c2 in c1.id < c2.id }) { chatroom in
            NavigationLink("#\(chatroom.id)", value: chatroom)
                .contextMenu {
                    ChatroomContextMenu(chatroom: chatroom)
                }
        }
    }
}
