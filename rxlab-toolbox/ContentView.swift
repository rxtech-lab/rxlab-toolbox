import MockTelegramKit
import SwiftUI

struct ContentView: View {
    @Environment(SheetManager.self) var sheetManager
    @Environment(AlertManager.self) var alertManager
    @Environment(ConfirmManager.self) var confirmManager

    @State private var selectedSidebarItem: NavigationPath?
    @State private var selectedWebhookDetail: Webhook?

    var body: some View {
        Group {
            NavigationSplitView {
                // Sidebar
                sidebarContent
            } detail: {
                NavigationStack {
                    if let selection = selectedSidebarItem {
                        switch selection {
                        case let .webhook(webhook):
                            WebhookDetail(webhook: webhook, showEditButton: true)
                        case let .chatroom(chatroom):
                            HSplitView {
                                ChatroomDetail(chatroom: chatroom)
                                if let selectedWebhookDetail {
                                    WebhookDetail(webhook: selectedWebhookDetail, showEditButton: false)
                                        .frame(minWidth: 200)
                                } else {
                                    Text("Select a webhook")
                                }
                            }
                        }
                    } else {
                        EmptyView()
                    }
                }
            }
        }
        .onChange(of: selectedSidebarItem, { _, new in
            Task {
                if let new = new {
                    await getWebhookDetail(path: new)
                }
            }
        })
        .confirmationDialog(
            confirmManager.confirmTitle,
            isPresented: confirmManager.isConfirmPresentedBinding,
            titleVisibility: .visible
        ) {
            Button(confirmManager.confirmButtonText, role: .destructive) {
                Task {
                    await confirmManager.handleConfirm()
                }
            }
            Button(confirmManager.cancelButtonText, role: .cancel) {
                confirmManager.handleCancel()
            }
        } message: {
            Text(confirmManager.confirmMessage)
        }
        .alert(alertManager.alertTitle,
               isPresented: alertManager.isAlertPresentedBinding,
               actions: {
                   Button("OK", role: .cancel) {
                       alertManager.hideAlert()
                   }
               }, message: {
                   Text(alertManager.alertMessage)
               })
        .sheet(isPresented: sheetManager.isSheetPresentedBinding) {
            sheetManager.sheetContent()
        }
        .navigationTitle(AppStrings.appName.rawValue)
        .navigationSplitViewStyle(.prominentDetail)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                StartOrStopServerButton()
            }
        }
    }

    private var sidebarContent: some View {
        List(selection: $selectedSidebarItem) {
            Section("Webhooks") {
                WebhookList { _ in
                    // delete current selection if the selected webhook is deleted
                    if let selectedSidebarItem = selectedSidebarItem,
                       case let .webhook(webhook) = selectedSidebarItem,
                       webhook.id == webhook.id {
                        self.selectedSidebarItem = nil
                    }
                }
            }

            Section("Chatrooms") {
                ChatroomList { _ in
                    if let selectedSidebarItem = selectedSidebarItem,
                       case let .chatroom(chatroom) = selectedSidebarItem,
                       chatroom.id == chatroom.id {
                        self.selectedSidebarItem = nil
                    }
                }
            }
        }
        .frame(minWidth: 250)
        .contextMenu {
            WebhookContextMenu()
            ChatroomContextMenu()
        }
    }

    @MainActor
    func getWebhookDetail(path: NavigationPath) async {
        switch path {
        case let .chatroom(chatroom):
            guard let webhook = await ChatManager.shared.getWebhook(chatroomId: chatroom.id) else {
                return
            }
            selectedWebhookDetail = Webhook.fromTGWebhook(webhook)
            break
        default:
            return
        }
    }
}

#Preview {
    ContentView()
}
