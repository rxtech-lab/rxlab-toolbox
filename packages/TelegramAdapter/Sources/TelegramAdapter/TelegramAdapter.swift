import Common

//
//  telegramAdapter.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/19/24.
//
import MockTelegramKit
import SwiftUI

public struct TelegramAdapter: Adapter {
    public init() {}

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: TelegramAdapter, rhs: TelegramAdapter) -> Bool {
        lhs.id == rhs.id
    }

    public var id = "telegram"

    public var contentView: some View {
        TelegramContentView()
    }

    public var detailView: some View {
        Text("Detail view")
    }

    public var sidebarItem: SidebarItem = .init(
        name: "Telegram", icon: "paperplane.fill", value: "telegram"
    ) {
        AnyView(
            Group {
                StartOrStopServerButton(variant: .sidebar)

            })
    }
}
