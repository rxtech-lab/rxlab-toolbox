import SwiftUI

@Observable class ConfirmManager {
    var isConfirmPresented: Bool = false
    var isConfirmPresentedBinding: Binding<Bool> {
        .init(get: { self.isConfirmPresented }, set: { self.isConfirmPresented = $0 })
    }

    private var title: String = ""
    private var message: String = ""
    private var confirmAction: (() async -> Void)?
    private var cancelAction: (() -> Void)?

    var confirmTitle: String {
        return title.isEmpty ? "Confirm" : title
    }

    var confirmMessage: String {
        return message
    }

    var confirmButtonText: String = "OK"
    var cancelButtonText: String = "Cancel"

    func showConfirmation(
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

    func handleConfirm() async {
        hideConfirm()
        await confirmAction?()
        _confirmAction = nil
        _cancelAction = nil
    }

    func handleCancel() {
        hideConfirm()
        cancelAction?()
    }

    func hideConfirm() {
        isConfirmPresented = false
        title = ""
        message = ""
    }
}
