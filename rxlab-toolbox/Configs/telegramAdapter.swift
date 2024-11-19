//
//  telegramAdapter.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/19/24.
//
import MockTelegramKit
import SwiftUI

struct TelegramAdapterData: AdapterData {
    var chatrooms: [Chatroom] = []
    var messages: [Int: [Message]] = [:]
    var webhooks: [Webhook] = []
}

struct TelegramAdapter: Adapter {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: TelegramAdapter, rhs: TelegramAdapter) -> Bool {
        lhs.id == rhs.id
    }

    var id = "telegram"

    var contentView: some View {
        TelegramContentView()
    }

    var detailView: some View {
        Text("Detail view")
    }

    var sidebarItem: SidebarItem = SidebarItem(name: "Telegram", icon: "paperplane.fill", value: "telegram")
}
