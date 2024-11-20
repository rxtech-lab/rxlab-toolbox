import SwiftUI

@Observable public class ConfirmManager: @unchecked Sendable {
    public var isConfirmPresented: Bool = false
    public var isConfirmPresentedBinding: Binding<Bool> {
        .init(get: { self.isConfirmPresented }, set: { self.isConfirmPresented = $0 })
    }

    private var title: String = ""
    private var message: String = ""
    private var confirmAction: (() async -> Void)?
    private var cancelAction: (() -> Void)?

    public init() {}

    public var confirmTitle: String {
        return title.isEmpty ? "Confirm" : title
    }

    public var confirmMessage: String {
        return message
    }

    public var confirmButtonText: String = "OK"
    public var cancelButtonText: String = "Cancel"

    public func showConfirmation(
        title: String = "Confirm",
        message: String,
        confirmButtonText: String = "OK",
        cancelButtonText: String = "Cancel",
        onConfirm: @escaping () async -> Void,
        onCancel: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.confirmButtonText = confirmButtonText
        self.cancelButtonText = cancelButtonText
        confirmAction = onConfirm
        cancelAction = onCancel
        isConfirmPresented = true
    }

    public func handleConfirm() async {
        hideConfirm()
        await confirmAction?()
        _confirmAction = nil
        _cancelAction = nil
    }

    public func handleCancel() {
        hideConfirm()
        cancelAction?()
    }

    public func hideConfirm() {
        isConfirmPresented = false
        title = ""
        message = ""
    }
}
