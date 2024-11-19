//
//  AdapterManager.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/20/24.
//

import SwiftUI

@Observable class AdapterManager {
    let adapters: [any Adapter] = [
        TelegramAdapter(),
    ]
}
