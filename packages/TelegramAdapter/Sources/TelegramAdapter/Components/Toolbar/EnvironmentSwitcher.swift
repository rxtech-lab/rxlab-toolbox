//
//  EnvironmentSwitcher.swift
//  TelegramAdapter
//
//  Created by Qiwei Li on 11/20/24.
//
import SwiftUI

struct EnvironmentToggle: View {
    @Binding var isDevelopment: Bool

    var body: some View {
        ControlGroup {
            Button(action: { isDevelopment = true }) {
                Label("Dev", systemImage: "hammer.fill")
            }
            .help("Switch to development mode")
            .background(isDevelopment ? Color.secondary.opacity(0.1) : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Button(action: { isDevelopment = false }) {
                Label("Test", systemImage: "testtube.2")
            }
            .help("Switch to testing mode")
            .background(!isDevelopment ? Color.secondary.opacity(0.1) : .clear)
            .foregroundColor(!isDevelopment ? .white : .gray)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        } label: {
            Label("Environment", systemImage: "gearshape.fill")
        }
        .animation(.spring(response: 0.3), value: isDevelopment)
    }
}

#Preview {
    NavigationView {
    }
    .toolbar {
        ToolbarItem(placement: .primaryAction) {
            EnvironmentToggle(isDevelopment: .constant(true))
        }
    }
}
