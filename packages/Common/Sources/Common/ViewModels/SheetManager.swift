import Foundation
import SwiftUI

@Observable public class SheetManager: @unchecked Sendable {
    public var isSheetPresented: Bool = false
    public var isSheetPresentedBinding: Binding<Bool> {
        .init(get: { self.isSheetPresented }, set: { self.isSheetPresented = $0 })
    }

    private var content: AnyView?

    public init() {}

    // Show sheet with any SwiftUI view
    public func showSheet<Content: View>(@ViewBuilder content: () -> Content) {
        self.content = AnyView(content())
        isSheetPresented = true
    }

    // Hide current sheet
    public func hideSheet() {
        isSheetPresented = false
        content = nil
    }

    // Get the current sheet content
    @ViewBuilder
    public func sheetContent() -> some View {
        if let content {
            content
        } else {
            EmptyView()
        }
    }
}
