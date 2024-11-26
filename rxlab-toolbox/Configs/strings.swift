//
//  strings.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/19/24.
//
import SwiftUI

//
//  strings.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/19/24.
//
import SwiftUI

enum AppStrings: LocalizedStringKey {
    case appName = "RxLab Toolbox"
    case adapterSection = "Adapters"
    case storageSection = "Storage"
    case apiSection = "API"
    enum Telegram: LocalizedStringKey {
        case adapterName = "Telegram Adapter"
    }

    enum Testplan: LocalizedStringKey {
        case testplanName = "Test Plan"
        case deleteTestplanConfirmation = "Are you sure you want to delete this test plan?"
        case deleteButton = "Delete Test Plan"
        case noTestplanDescription = "No test plans available"
    }
}
