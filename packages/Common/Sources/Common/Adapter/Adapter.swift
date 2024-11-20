//
//  Adapter.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/19/24.
//
import SwiftUI

public enum ActionVariant {
    case toolbar
    case sidebar
}

public struct SidebarItem: Identifiable {
    public var name: String
    public var icon: String
    public var value: any Hashable
    public var id: String {
        name
    }

    @ViewBuilder public var action: () -> AnyView

    public init(name: String, icon: String, value: any Hashable, @ViewBuilder action: @escaping () -> AnyView) {
        self.name = name
        self.icon = icon
        self.value = value
        self.action = action
    }
}

/// Adapter defines the protocol for different chat interface. Similar to rxbot's design
/// rxbot can support different chat platforms by implementing different adapters.
/// The testing tool should also support different chat platforms by implementing different adapters.
///
/// For example, the TelegramAdapter will use MockTelegramKit for the telegrams's functionality.
public protocol Adapter: Identifiable, Equatable, Hashable {
    var id: String { get }
    var contentView: Content { get }
    var detailView: Detail { get }
    var sidebarItem: SidebarItem { get }
    associatedtype Content: View
    associatedtype Detail: View
}
