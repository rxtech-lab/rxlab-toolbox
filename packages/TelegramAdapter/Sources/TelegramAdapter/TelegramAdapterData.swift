//
//  TelegramAdapterData.swift
//  TelegramAdapter
//
//  Created by Qiwei Li on 11/20/24.
//
import Common
import MockTelegramKit

public struct TelegramAdapterData: AdapterData {
    public var messages: [Int: [Message]] = [:]
    public var webhooks: [Int: Webhook] = [:]
    public var messageId: Int = 0
    public var chatroomId: Int = 0

    public init() {}

    public init(messages: [Int: [Message]], webhooks: [Int: Webhook], messageId: Int, chatroomId: Int) {
        self.messages = messages
        self.webhooks = webhooks
        self.messageId = messageId
        self.chatroomId = chatroomId
    }
}
