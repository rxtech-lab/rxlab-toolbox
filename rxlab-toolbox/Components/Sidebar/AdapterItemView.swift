import Common
import SwiftUI
import TelegramAdapter

struct AdapterItemView: View {
    let adapter: any Adapter
    @Binding var document: RxToolboxDocument
    @State private var isHovered = false

    var body: some View {
        NavigationLink(value: NavigationPath.SideBar(.Adapter(adapter))) {
            HStack {
                // Main content
                Label(adapter.sidebarItem.name, systemImage: adapter.sidebarItem.icon)
                    .transaction { t in
                        t.animation = nil
                    }
                Spacer()
                // Delete button
                if isHovered {
                    adapter.sidebarItem.action()
                }
            }
        }
        .contextMenu {
            AdapterContextMenu(document: $document, adapter: adapter)
        }
        .onTapGesture {
            print("Tapped")
        }
        .contentShape(Rectangle()) // Makes the entire row hoverable
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
}
