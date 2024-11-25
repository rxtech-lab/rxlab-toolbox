//
//  Navigation.swift
//  mock-telegram-app
//
//  Created by Qiwei Li on 11/14/24.
//
import Common
import TestKit

enum SideBarItem: Hashable {
    case Adapter(any Adapter & Hashable)
    case TestPlan(TestPlan)

    func hash(into hasher: inout Hasher) {
        switch self {
        case .Adapter(let adapter):
            hasher.combine(adapter)
        case .TestPlan(let testPlan):
            hasher.combine(testPlan)
        }
    }

    static func == (lhs: SideBarItem, rhs: SideBarItem) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

enum NavigationPath: Hashable {
    case SideBar(SideBarItem)
}
