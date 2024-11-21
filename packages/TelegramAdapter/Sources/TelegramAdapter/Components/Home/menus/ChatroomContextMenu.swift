import Common
import MockTelegramKit
import SwiftUI

struct ChatroomContextMenu: View {
    @Environment(SheetManager.self) var sheetManager
    @Environment(ConfirmManager.self) var confirmManager
    let chatroom: Chatroom?
    @Binding var selectedChatroom: Chatroom?

    init(chatroom: Chatroom? = nil, selectedChatroom: Binding<Chatroom?>) {
        self.chatroom = chatroom
        self._selectedChatroom = selectedChatroom
    }

    init() {
        self.chatroom = nil
        self._selectedChatroom = .constant(nil)
    }

    var body: some View {
        Group {
            if chatroom == nil {
                Button {
                    sheetManager.showSheet {
                        CreateChatroomForm()
                            .frame(width: 450)
                            .padding()
                    }
                } label: {
                    Text("Add new chatroom")
                }
            }

            if let chatroom = chatroom {
                Button {
                    confirmManager.showConfirmation(message: "Are you sure you want to delete this chatroom?") {
                        await ChatManager.shared.deleteChatroom(chatroomId: chatroom.id)
                        selectedChatroom = nil
                    }
                } label: {
                    Text("Delete chatroom")
                }
            }
        }
    }
}
