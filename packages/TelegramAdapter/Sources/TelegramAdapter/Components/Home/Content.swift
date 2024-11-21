//
//  Content.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/19/24.
//

import Common
import SwiftUI

struct TelegramContentView: View {
    @Environment(SheetManager.self) var sheetManager
    @State var selectedChatroom: Chatroom?
    @State var isDevelopment: Bool = true

    @ViewBuilder func buildList() -> some View {
        List(selection: $selectedChatroom) {
            Section {
                ChatroomList(selectedChatroom: $selectedChatroom) { _ in
                }
            } header: {
                HStack {
                    Text("Chatrooms")
                    Spacer()
                    Button {
                        sheetManager.showSheet {
                            CreateChatroomForm()
                                .frame(width: 450)
                                .padding()
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
        .contextMenu {
            ChatroomContextMenu()
        }
    }

    var body: some View {
        HSplitView {
            buildList()
                .frame(width: 250)
            if let selectedChatroom = selectedChatroom {
                ChatroomDetail(chatroom: selectedChatroom)

            } else {
                Text("Detail view")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                EnvironmentToggle(isDevelopment: $isDevelopment)
            }
            ToolbarItem {
                HStack {
                    Divider()
                }
            }
            ToolbarItem(placement: .primaryAction) {
                StartOrStopServerButton(variant: .toolbar)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
