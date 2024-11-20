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

    public init() {
        Task {
            await ChatManager.shared.registerWebhookListeners.receive(on: DispatchQueue.main).sink {
                _ in
                Task {
                    // Cannot assign value of type '[Int : URL]' to type '[Webhook]'
                    DispatchQueue.main.async {
                        Task {
                            self.webhooks = await ChatManager.shared.getAllWebhooks()
                                .map { $0.value }
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
                            .map { $0.value }
                        self.chatroom = await ChatManager.shared.getAllChatrooms().map {
                            Chatroom(id: $0)
                        }
                    }
                }
            }.store(in: &cancellables)
        }
    }
}
