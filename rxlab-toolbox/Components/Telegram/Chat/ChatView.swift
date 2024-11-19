import Foundation
import MockTelegramKit
import SwiftUI

// MARK: - Chat View

struct ChatView: View {
    let chatroom: Chatroom
    let messages: [Message]
    let onSendMessage: (String) async -> Void

    @State private var messageText: String = ""
    @FocusState private var isInputFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Messages List
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(messages, id: \.messageId) { message in
                            MessageView(message: message) { button in
                                Task {
                                    await ChatManager.shared.clickOnMessageButton(chatroomId: chatroom.id, message: message, button: button)
                                }
                            }
                            .id(message.messageId)
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 8)
                }
                .onChange(of: messages) {
                    if let lastId = messages.last?.messageId {
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }

            // Input Area
            ChatInputView(
                text: $messageText,
                isFocused: _isInputFocused,
                onSend: {
                    guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                    let text = messageText
                    messageText = ""
                    await onSendMessage(text)
                }
            )
        }
    }
}

struct MessageDateFormatter {
    static func format(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Input View

struct ChatInputView: View {
    @Binding var text: String
    @FocusState var isFocused: Bool
    let onSend: () async -> Void

    var body: some View {
        HStack(spacing: 8) {
            TextField("Message", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($isFocused)
                .onSubmit {
                    Task {
                        await onSend()
                    }
                }

            Button(action: {
                Task {
                    await onSend()
                }
            }) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.blue)
            }
            .padding(.trailing, 8)
            .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(Color(nsColor: .windowBackgroundColor))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.2)),
            alignment: .top
        )
    }
}

// MARK: - Preview

#Preview {
    ChatView(chatroom: .init(id: 1), messages: [
        .init(messageId: 1, text: "Hello", userId: .BotUserId),
        .init(messageId: 2, text: "Hi", userId: .UserID),
        .init(messageId: 3, text: "Hi", userId: .UserID),
        .init(messageId: 4, text: "Hello", userId: .BotUserId, replyMarkup: .init(inlineKeyboard: [[
            .init(text: "Hello", callbackData: ""),
            .init(text: "Hello", callbackData: ""),
        ]])),
    ]) { _ in
    }
}