//
//  Content.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/19/24.
//

import SwiftUI

struct TelegramContentView: View {
    @Environment(SheetManager.self) var sheetManager

    var body: some View {
        List {
            Section {
                ChatroomList { _ in
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
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                StartOrStopServerButton(variant: .toolbar)
            }
        }
    }
}
