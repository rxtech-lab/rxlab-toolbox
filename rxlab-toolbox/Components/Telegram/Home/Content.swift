//
//  Content.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/19/24.
//

import SwiftUI

struct TelegramContentView: View {
    @Environment(SheetManager.self) var sheetManager

    @ViewBuilder func buildList() -> some View {
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
    }

    var body: some View {
        HSplitView {
            buildList()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            EmptyView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                StartOrStopServerButton(variant: .toolbar)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
