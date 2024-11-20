//
//  AdapterManager.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/20/24.
//

import Common
import SwiftUI
import TelegramAdapter

enum AvailableAdapters: String, CaseIterable {
    case telegram
}

@Observable class AdapterManager {
    private(set) var adapters: [any Adapter] = [
    ]

    func addAdapter(adapter: AvailableAdapters) {
        switch adapter {
        case .telegram:
            adapters.append(TelegramAdapter())
        }
    }
}
