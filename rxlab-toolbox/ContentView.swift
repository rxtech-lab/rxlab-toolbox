import Common
import MockTelegramKit
import SwiftUI

struct ContentView: View {
    @Environment(SheetManager.self) var sheetManager
    @Environment(AlertManager.self) var alertManager
    @Environment(ConfirmManager.self) var confirmManager
    @Environment(AdapterManager.self) var adapterManager
    @Binding var document: RxToolboxDocument

    @State private var selectedSidebarItem: NavigationPath?
    @State private var selectedWebhookDetail: Webhook?

    var body: some View {
        NavigationSplitView {
            // Sidebar
            sidebarContent
                .contextMenu {
                    AdapterContextMenu(document: $document)
                }
        } detail: {
            contentView
        }
        .confirmationDialog(
            confirmManager.confirmTitle,
            isPresented: confirmManager.isConfirmPresentedBinding,
            titleVisibility: .visible
        ) {
            Button(confirmManager.confirmButtonText, role: .destructive) {
                Task {
                    await confirmManager.handleConfirm()
                }
            }
            Button(confirmManager.cancelButtonText, role: .cancel) {
                confirmManager.handleCancel()
            }
        } message: {
            Text(confirmManager.confirmMessage)
        }
        .alert(alertManager.alertTitle,
               isPresented: alertManager.isAlertPresentedBinding,
               actions: {
                   Button("OK", role: .cancel) {
                       alertManager.hideAlert()
                   }
               }, message: {
                   Text(alertManager.alertMessage)
               })
        .sheet(isPresented: sheetManager.isSheetPresentedBinding) {
            sheetManager.sheetContent()
        }
        .onAppear {
            if !document.hasInitialized {
                sheetManager.showSheet {
                    SplashScreen(document: $document)
                        .frame(height: 600)
                }
            }

            for adapter in document.adapters {
                adapterManager.addAdapter(adapter: adapter)
            }
        }
        .navigationTitle(AppStrings.appName.rawValue)
        .navigationSplitViewStyle(.prominentDetail)
    }

    private var sidebarContent: some View {
        List(selection: $selectedSidebarItem) {
            Section(AppStrings.adapterSection.rawValue) {
                ForEach(adapterManager.adapters, id: \.id) { adapter in
                    AdapterItemView(adapter: adapter)
                }
            }

            Section(AppStrings.storageSection.rawValue) {}

            Section(AppStrings.apiSection.rawValue) {}
        }
        .frame(minWidth: 300)
    }

    @ViewBuilder
    private var contentView: some View {
        switch selectedSidebarItem {
        case let .SideBar(.Adapter(adapter)):
            AnyView(adapter.contentView)
        default:
            EmptyStateView(iconName: "tray.full", title: "No detail to display", message: "Select an item to view details")
        }
    }
}

#Preview {
    ContentView(document: .constant(.init()))
}
