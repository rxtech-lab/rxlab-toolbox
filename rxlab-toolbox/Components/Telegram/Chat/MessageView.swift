import MockTelegramKit
import SwiftUI

struct MessageView: View {
    let message: Message
    private let currentUserId = getCurrentUserId()
    let onButtonPress: ((InlineKeyboardButton) -> Void)?

    init(message: Message, onButtonPress: ((InlineKeyboardButton) -> Void)? = nil) {
        self.message = message
        self.onButtonPress = onButtonPress
    }

    func hasInlineKeyboard() -> Bool {
        return message.replyMarkup != nil
    }

    func hasEdited() -> Bool {
        return message.updateCount > 0
    }

    var body: some View {
        HStack {
            if message.userId == currentUserId {
                Spacer()
                messageContent
            } else {
                messageContent
                Spacer()
            }
        }
        .frame(minWidth: 500)
    }

    var messageContent: some View {
        VStack(alignment: message.userId == currentUserId ? .trailing : .leading, spacing: 8) {
            // Message bubble
            messageBubble
                .background(message.userId == currentUserId ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            if hasEdited() {
                Text("Edited \(message.updateCount) time(s)")
                    .font(.caption2)
            }

            // Inline keyboard buttons (outside bubble)
            if let replyMarkup = message.replyMarkup,
               let keyboard = replyMarkup.inlineKeyboard {
                if keyboard.count > 0 {
                    VStack {
                        ForEach(keyboard, id: \.self) { row in
                            HStack(spacing: 4) {
                                ForEach(row.indices, id: \.self) { index in
                                    let button = row[index]
                                    inlineButton(button)
                                }
                            }
                        }
                    }
                    .frame(width: 300)
                }
            }
        }
        .padding()
    }

    var messageBubble: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("User \(message.userId)")
                .font(.caption)
                .foregroundColor(.blue)

            if let text = message.text {
                HTMLRenderer(html: text)
            }

            Text(MessageDateFormatter.format(timestamp: Int(Date().timeIntervalSince1970)))
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding(8)
    }

    @ViewBuilder
    private func inlineButton(_ button: InlineKeyboardButton) -> some View {
        Button(action: {
            onButtonPress?(button)
        }) {
            Text(button.text)
                .truncationMode(.middle)
                .font(.callout)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 30)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .buttonStyle(PlainButtonStyle())
    }

    private static func getCurrentUserId() -> Int {
        // Replace with actual current user ID logic
        return .UserID
    }
}

#Preview {
    MessageView(message: .init(messageId: 1, text: "Hello\nHello world world world world world world", userId: .UserID)) { _ in
    }
    .padding()
    .frame(maxWidth: 400)
}

#Preview {
    MessageView(message: .init(messageId: 1, text: "Hello\nHello world world world world world world", userId: .UserID)) { _ in
    }
    MessageView(message: .init(messageId: 4, text: "Hello", userId: .BotUserId, replyMarkup: .init(inlineKeyboard: [[
        .init(text: "Hello", callbackData: ""),
        .init(text: "Hello", callbackData: ""),
    ], [
        .init(text: "Hello", callbackData: ""),
        .init(text: "Hello", callbackData: ""),
    ]]))) { _ in
    }
    .padding()
}
