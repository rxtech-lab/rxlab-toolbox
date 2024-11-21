//
//  MockTelegramKitManager.swift
//  mock-telegram-app
//
//  Created by Qiwei Li on 11/14/24.
//
@preconcurrency import Combine
import MockTelegramKit
import SwiftUI

struct Chatroom: Codable, Identifiable, Hashable {
    let id: Int
}

@Observable public class MockTelegramKitManager {
    private var cancellables = Set<AnyCancellable>()
    private(set) var webhooks: [Webhook] = []
    private(set) var chatroom: [Chatroom] = []

    public init() {}

    public func initialize(onUpdate: @escaping () async -> Void) async {
        await ChatManager.shared.registerWebhookListeners.receive(on: DispatchQueue.main).sink {
            _ in
            Task {
                // Cannot assign value of type '[Int : URL]' to type '[Webhook]'
                Task(priority: .background) {
                    self.webhooks = await ChatManager.shared.getAllWebhooks()
                        .map { $0.value }
                    await onUpdate()
                }
            }
        }
        .store(in: &cancellables)

        await ChatManager.shared.chatroomListeners.receive(on: DispatchQueue.main).sink { _ in
            Task(priority: .low) {
                self.chatroom = await ChatManager.shared.getAllChatrooms().map {
                    Chatroom(id: $0)
                }
                await onUpdate()
            }
        }.store(in: &cancellables)

        await ChatManager.shared.resetListeners.receive(on: DispatchQueue.main).sink { _ in
            Task(priority: .medium) {
                self.webhooks = await ChatManager.shared.getAllWebhooks()
                    .map { $0.value }
                self.chatroom = await ChatManager.shared.getAllChatrooms().map {
                    Chatroom(id: $0)
                }
                await onUpdate()
            }
        }.store(in: &cancellables)
    }

    public func save() async -> TelegramAdapterData {
        let (messages, webhooks, chatId, messageId) = await ChatManager.shared.save()
        return TelegramAdapterData(messages: messages, webhooks: webhooks, messageId: messageId, chatroomId: chatId)
    }

    public func load(data: TelegramAdapterData) async {
        await ChatManager.shared.load(messages: data.messages, webhooks: data.webhooks, chatId: data.chatroomId, messageId: data.messageId)

        chatroom = await ChatManager.shared.getAllChatrooms().map {
            Chatroom(id: $0)
        }
    }
}
