//
//  EmptyView.swift
//  mock-telegram-app
//
//  Created by Qiwei Li on 11/18/24.
//

import SwiftUI

struct EmptyView: View {
    @Environment(SheetManager.self) var sheetManager

    var body: some View {
        VStack(spacing: 10) {
            Text("Emtpy Content")
                .font(.title)
                .fontWeight(.bold)
            Text("You don't have any Chat Rooms yet.")
            Button("Create a Chat Room") {
                sheetManager.showSheet {
                    CreateChatroomForm()
                        .frame(width: 450)
                        .padding()
                }
            }
        }
        .padding()
    }
}

#Preview {
    EmptyView()
}
