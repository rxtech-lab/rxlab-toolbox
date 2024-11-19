//
//  Adapter.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/19/24.
//
import SwiftUI

struct SidebarItem: Identifiable {
    var name: String
    var icon: String
    var value: any Hashable
    var id: String {
        name
    }
}

/// Adapter defines the protocol for different chat interface. Similar to rxbot's design
/// rxbot can support different chat platforms by implementing different adapters.
/// The testing tool should also support different chat platforms by implementing different adapters.
///
/// For example, the TelegramAdapter will use MockTelegramKit for the telegrams's functionality.
protocol Adapter: Identifiable, Equatable, Hashable {
    var contentView: Content { get }
    var detailView: Detail { get }
    var sidebarItem: SidebarItem { get }
    associatedtype Content: View
    associatedtype Detail: View
}
