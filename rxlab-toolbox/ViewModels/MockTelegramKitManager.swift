//
//  MockTelegramKitManager.swift
//  mock-telegram-app
//
//  Created by Qiwei Li on 11/14/24.
//
import Combine
import MockTelegramKit
import SwiftUI

struct Webhook: Identifiable, Hashable {
    let id: UUID
    let chatroomId: Int
    let url: URL
    let isAvtive: Bool
    let lastError: String?
    let lastUpdate: Date?

    static func fromTGWebhook(_ tgWebhook: TGWebhook) -> Self {
        Self(id: tgWebhook.id, chatroomId: tgWebhook.chatroomId, url: tgWebhook.url, isAvtive: tgWebhook.isActive, lastError: tgWebhook.lastError, lastUpdate: tgWebhook.lastUpdate)
    }
}

struct Chatroom: Identifiable, Hashable {
    let id: Int
}

@Observable class MockTelegramKitManager {
    private var cancellables = Set<AnyCancellable>()
    private(set) var webhooks: [Webhook] = []
    private(set) var chatroom: [Chatroom] = []

    init() {
        Task {
            await ChatManager.shared.registerWebhookListeners.receive(on: DispatchQueue.main).sink { _, _ in
                Task {
                    // Cannot assign value of type '[Int : URL]' to type '[Webhook]'
                    DispatchQueue.main.async {
                        Task {
                            self.webhooks = await ChatManager.shared.getAllWebhooks()
                                .map { Webhook.fromTGWebhook($0.value) }
                        }
                    }
                }
            }
            .store(in: &cancellables)

            await ChatManager.shared.chatroomListeners.receive(on: DispatchQueue.main).sink { _ in
                Task {
                    self.chatroom = await ChatManager.shared.getAllChatrooms().map {
                        Chatroom(id: $0)
                    }
                }
            }.store(in: &cancellables)

            await ChatManager.shared.resetListeners.receive(on: DispatchQueue.main).sink { _ in
                DispatchQueue.main.async {
                    Task {
                        self.webhooks = await ChatManager.shared.getAllWebhooks()
                            .map { Webhook.fromTGWebhook($0.value) }
                        self.chatroom = await ChatManager.shared.getAllChatrooms().map {
                            Chatroom(id: $0)
                        }
                    }
                }
            }.store(in: &cancellables)
        }
    }
}
