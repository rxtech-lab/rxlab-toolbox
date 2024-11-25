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

    static func from(adapter: any Adapter) -> AvailableAdapters? {
        switch adapter {
        case is TelegramAdapter:
            return .telegram
        default:
            return nil
        }
    }
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

    func removeAdapter(adapter: any Adapter) {
        if let index = adapters.firstIndex(where: { a in
            a.id == adapter.id
        }) {
            adapters.remove(at: index)
        }
    }
}
