import Foundation
import SwiftUI

@Observable class SheetManager {
    var isSheetPresented: Bool = false
    var isSheetPresentedBinding: Binding<Bool> {
        .init(get: { self.isSheetPresented }, set: { self.isSheetPresented = $0 })
    }

    private var content: AnyView?

    // Show sheet with any SwiftUI view
    func showSheet<Content: View>(@ViewBuilder content: () -> Content) {
        self.content = AnyView(content())
        isSheetPresented = true
    }

    // Hide current sheet
    func hideSheet() {
        isSheetPresented = false
        content = nil
    }

    // Get the current sheet content
    @ViewBuilder
    func sheetContent() -> some View {
        if let content {
            content
        } else {
            EmptyView()
        }
    }
}
