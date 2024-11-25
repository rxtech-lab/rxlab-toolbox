import Common
import MockTelegramKit
import SwiftUI

struct DetailRow: View {
    let title: String
    let value: String
    var textColor: Color = .primary

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.body)
                .foregroundColor(textColor)
                .textSelection(.enabled)
        }
        .padding(.vertical, 4)
    }
}

struct WebhookDetail: View {
    let webhook: Webhook
    @State private var isEditing = false
    @Environment(MockTelegramKitManager.self) private var chatManager
    let showEditButton: Bool

    var body: some View {
        let currentWebhook = chatManager.webhooks.first(where: { $0.id == webhook.id }) ?? webhook
        VStack {
            if showEditButton {
                Spacer()
            }
            List {
                // Basic Information Section
                Section("Basic Information") {
                    DetailRow(title: "Chatroom ID", value: "\(currentWebhook.chatroomId)")
                    DetailRow(title: "Webhook URL", value: currentWebhook.url.absoluteString)
                    DetailRow(
                        title: "Status", value: currentWebhook.isActive ? "🟢 Active" : "🔴 Inactive")
                }

                // Status Information Section
                Section("Status Information") {
                    DetailRow(
                        title: "Last Update",
                        value: formatDate(currentWebhook.lastUpdate)
                    )

                    if let error = currentWebhook.lastError {
                        DetailRow(
                            title: "Last Error",
                            value: error,
                            textColor: .red
                        )
                    }
                }
            }
            .toolbar {
                if showEditButton {
                    ToolbarItem {
                        Button(action: { isEditing.toggle() }) {
                            Label("Edit Webhook", systemImage: "pencil")
                        }
                        .help("Edit webhook details")
                    }
                }
            }
            .sheet(isPresented: $isEditing) {
                WebhookEditView(webhook: currentWebhook)
            }
        }
    }

    private func formatDate(_ date: Date?) -> String {
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return "N/A"
    }
}

struct WebhookEditView: View {
    let webhook: Webhook
    @Environment(\.dismiss) private var dismiss
    @Environment(AlertManager.self) private var alertManager
    @State private var url: String
    @State private var chatroomId: Int

    init(webhook: Webhook) {
        self.webhook = webhook
        _url = State(initialValue: webhook.url.absoluteString)
        _chatroomId = State(initialValue: webhook.chatroomId)
    }

    var body: some View {
        Form {
            Section("Webhook Configuration") {
                TextField("Chatroom ID", value: $chatroomId, formatter: NumberFormatter())
                TextField("Webhook URL", text: $url)
            }
        }
        .padding()
        .navigationTitle("Edit Webhook")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task {
                        guard let url = URL(string: url) else {
                            dismiss()
                            alertManager.showAlert(message: "Invalid URL")
                            return
                        }

                        do {
                            _ = try await ChatManager.shared.updateWebhook(
                                webhook: .init(
                                    id: webhook.id,
                                    chatroomId: chatroomId,
                                    url: url
                                )
                            )
                            dismiss()

                        } catch let error as LocalizedError {
                            alertManager.showAlert(error)
                        }
                    }
                }
            }
        }
    }
}
