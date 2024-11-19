//
//  WelcomeOptionButton.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/19/24.
//
import SwiftUI

struct WelcomeOptionButton: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .frame(width: 20)
                Text(title)
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
        }
        .buttonStyle(.plain)
        .background(Color(.systemGray).opacity(0.1))
        .cornerRadius(6)
    }
}
