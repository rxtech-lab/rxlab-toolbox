//
//  AdapterContextMenu.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/20/24.
//
import Common
import SwiftUI

struct AdapterForm: View {
    @Binding var document: RxToolboxDocument
    @Environment(AdapterManager.self) var adapterManager
    @State var selectedAdapter: AvailableAdapters = .telegram
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {
            Text("Add adapter")
            Picker("Adapter", selection: $selectedAdapter) {
                ForEach(AvailableAdapters.allCases, id: \.self) { adapter in
                    Text(adapter.rawValue)
                        .tag(adapter)
                }
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    adapterManager.addAdapter(adapter: selectedAdapter)
                    document.adapters.append(selectedAdapter)
                    dismiss()
                }
            }
        }
    }
}

struct AdapterContextMenu: View {
    @Binding var document: RxToolboxDocument
    @Environment(SheetManager.self) var sheetManager

    var body: some View {
        Button {
            sheetManager.showSheet {
                AdapterForm(document: $document)
            }
        } label: {
            Label("Add adapter", systemImage: "plus")
        }
    }
}
