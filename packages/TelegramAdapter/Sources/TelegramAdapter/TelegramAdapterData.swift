//
//  TelegramAdapterData.swift
//  TelegramAdapter
//
//  Created by Qiwei Li on 11/20/24.
//
import Common
import MockTelegramKit

public struct TelegramAdapterData: AdapterData {
    var chatrooms: [Chatroom] = []
    var messages: [Int: [Message]] = [:]
    var webhooks: [Webhook] = []

    public init() {}
}
