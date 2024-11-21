//
//  Extension+Popover.swift
//  TelegramAdapter
//
//  Created by Qiwei Li on 11/21/24.
//
import SwiftUI

struct PopoverMultilineHeightFix: ViewModifier {
    @State var textHeight: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .fixedSize(horizontal: false, vertical: true)
            .overlay(
                GeometryReader { proxy in
                    Color
                        .clear
                        .preference(key: ContentLengthPreference.self,
                                    value: proxy.size.height)
                }
            )
            .onPreferenceChange(ContentLengthPreference.self) { value in
                DispatchQueue.main.async {
                    self.textHeight = value
                }
            }
            .frame(height: self.textHeight)
    }
}

extension PopoverMultilineHeightFix {
    struct ContentLengthPreference: PreferenceKey {
        static var defaultValue: CGFloat { 0 }

        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
}

public extension View {
    func popoverMultilineHeightFix() -> some View {
        modifier(PopoverMultilineHeightFix())
    }
}
