//
//  RecordMessagesModifier.swift
//  TestKit
//
//  Created by Qiwei Li on 11/24/24.
//

import SwiftUI

public struct RecordMessagesModifier: ViewModifier {
    @Environment(TestkitManager.self) var testkitManager
    let messagesCount: Int

    init(messagesCount: Int) {
        self.messagesCount = messagesCount
    }

    public func body(content: Content) -> some View {
        content
            .onChange(of: messagesCount) { _, newValue in
                testkitManager.currentMessageCount = newValue
            }
    }
}

public extension View {
    func recordMessages(messagesCount: Int) -> some View {
        modifier(RecordMessagesModifier(messagesCount: messagesCount))
    }
}
