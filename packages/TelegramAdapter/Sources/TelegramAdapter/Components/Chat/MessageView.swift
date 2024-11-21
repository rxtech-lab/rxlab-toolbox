import Common
import MockTelegramKit
import SwiftUI

struct MessageView: View {
    let message: Message
    private let currentUserId = getCurrentUserId()
    let onButtonPress: ((InlineKeyboardButton) -> Void)?
    @State var showErrorMessage = false
    @State var size: CGSize = .zero

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

    @ViewBuilder func errorMessageIcon(direction: Edge) -> some View {
        if let error = message.error {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(.red)
                .onTapGesture {
                    showErrorMessage.toggle()
                }
                .popover(isPresented: $showErrorMessage, arrowEdge: direction) {
                    ZStack {
                        Color.red.scaleEffect(1.2)
                        Text(error.localizedDescription)
                            .multilineTextAlignment(.leading)
                            .popoverMultilineHeightFix()
                            .lineLimit(8)
                            .foregroundStyle(.white)
                            .frame(maxWidth: 400)
                            .fixedSize(horizontal: false, vertical: false)
                            .padding()
                    }
                }
        }
    }

    var body: some View {
        HStack {
            if message.userId == currentUserId {
                Spacer(minLength: min(200, 0.6 * size.width))
                errorMessageIcon(direction: .leading)
                messageContent
            } else {
                messageContent
                errorMessageIcon(direction: .trailing)
                Spacer(minLength: min(200, 0.6 * size.width))
            }
        }
        .saveSize(in: $size)
        .frame(minWidth: 500)
    }

    var messageContent: some View {
        VStack(alignment: message.userId == currentUserId ? .trailing : .leading, spacing: 8) {
            // Message bubble
            messageBubble
                .background(
                    message.error != nil ? Color.red :
                        message.userId == currentUserId
                        ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))

            if hasEdited() {
                Text("Edited \(message.updateCount) time(s)")
                    .font(.caption2)
            }

            // Inline keyboard buttons (outside bubble)
            if let replyMarkup = message.replyMarkup,
               let keyboard = replyMarkup.inlineKeyboard
            {
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
        .padding([.top, .bottom])
        .padding(message.userId == .BotUserId ? .leading : .trailing)
        .animation(.spring, value: message)
    }

    var messageBubble: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("User \(message.userId)")
                .font(.caption)
                .foregroundColor(message.error != nil ? .white : .blue)

            if let text = message.text {
                HTMLRenderer(html: text)
                    .foregroundStyle(message.error != nil ? .white : .primary)
            }

            Text(MessageDateFormatter.format(timestamp: Int(Date().timeIntervalSince1970)))
                .font(.caption2)
                .foregroundColor(message.error != nil ? .white : .gray)
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
    var message = Message(messageId: 1, text: "Hello", userId: 0)
    message.error = WebhookError.webhookCallFailed("Some very very long error message.Some very very long error message.Some very very long error message.Some very very long error message.Some very very long error message.Some very very long error message.")

    return MessageView(message: message) { _ in
    }
}
