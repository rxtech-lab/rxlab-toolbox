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
        }
            content: {
            contentView
        }
            detail: {
        }
        .frame(idealHeight: 800)
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
        }
        .navigationTitle(AppStrings.appName.rawValue)
        .navigationSplitViewStyle(.prominentDetail)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                StartOrStopServerButton()
            }
        }
    }

    private var sidebarContent: some View {
        List(selection: $selectedSidebarItem) {
            Section(AppStrings.adapterSection.rawValue) {
                ForEach(adapterManager.adapters, id: \.sidebarItem.id) { adapter in
                    NavigationLink(value: NavigationPath.SideBar(.Adapter(adapter))) {
                        Label(AppStrings.Telegram.adapterName.rawValue, systemImage: "bolt.fill")
                    }
                }
            }

            Section(AppStrings.storageSection.rawValue) {
            }

            Section(AppStrings.apiSection.rawValue) {
            }
        }
        .frame(minWidth: 200)
        .contextMenu {
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch selectedSidebarItem {
        case let .SideBar(.Adapter(adapter)):
            AnyView(adapter.contentView)
        default:
            Text("Select an adapter")
        }
    }

    @ViewBuilder
    private var detailView: some View {
        Text("")
    }
}

#Preview {
    ContentView(document: .constant(.init()))
}
