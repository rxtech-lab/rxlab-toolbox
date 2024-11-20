import Common
import MockTelegramKit
import SwiftUI

struct ChatroomContextMenu: View {
    @Environment(SheetManager.self) var sheetManager
    let chatroom: Chatroom? = nil

    var body: some View {
        VStack {
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
    }
}
