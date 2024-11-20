//
//  Navigation.swift
//  mock-telegram-app
//
//  Created by Qiwei Li on 11/14/24.
//
import Common

enum SideBarItem: Hashable {
    case Adapter(any Adapter & Hashable)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .Adapter(let adapter):
            hasher.combine(adapter)
        }
    }
    
    static func == (lhs: SideBarItem, rhs: SideBarItem) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

enum NavigationPath: Hashable {
    case SideBar(SideBarItem)
}
