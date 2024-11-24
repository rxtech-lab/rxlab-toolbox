//
//  RecordButtonModifier.swift
//  TestKit
//
//  Created by Qiwei Li on 11/24/24.
//
import SwiftUI

/**
 RecordButtonModifier is a test modifier that records the button click event for a specific message.
 */
public struct RecordButtonModifier: ViewModifier {
    private let text: String
    private let messageId: Int

    public init(with text: String, at messageId: Int) {
        self.text = text
        self.messageId = messageId
    }

    public func body(content: Content) -> some View {
        content
            .simultaneousGesture(TapGesture().onEnded {})
    }
}
