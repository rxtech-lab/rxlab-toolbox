//
//  AdapterManager.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/20/24.
//

import Common
import SwiftUI
import TelegramAdapter

enum AvailableAdapters: String, CaseIterable, Codable {
    case telegram
}

@Observable class AdapterManager {
    private(set) var adapters: [any Adapter] = [
    ]

    func addAdapter(adapter: AvailableAdapters) {
        switch adapter {
        case .telegram:
            let adapter = TelegramAdapter()
            if !adapters.contains(where: { $0.id == adapter.id }) {
                adapters.append(adapter)
            }
        }
    }
}
