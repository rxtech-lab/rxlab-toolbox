import SwiftUI

@Observable class AlertManager {
    var isAlertPresented: Bool = false
    var isAlertPresentedBinding: Binding<Bool> {
        .init(get: { self.isAlertPresented }, set: { self.isAlertPresented = $0 })
    }

    private var error: (any LocalizedError)?
    private var message: String?

    var alertTitle: String {
        return "Error"
    }

    var alertMessage: String {
        error?.errorDescription ?? message ?? "Unknown error"
    }

    func showAlert(_ error: LocalizedError) {
        self.error = error
        isAlertPresented = true
    }

    func showAlert(message: String) {
        self.message = message
        isAlertPresented = true
    }

    func hideAlert() {
        isAlertPresented = false
        error = nil
    }
}
