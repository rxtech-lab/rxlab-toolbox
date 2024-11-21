//
//  Size.swift
//  Common
//
//  Created by Qiwei Li on 11/20/24.
//
import SwiftUI

public struct SizeCalculator: ViewModifier {
    @Binding var size: CGSize

    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear // we just want the reader to get triggered, so let's use an empty color
                        .onAppear {
                            size = proxy.size
                        }
                }
            )
    }
}

public extension View {
    func saveSize(in size: Binding<CGSize>) -> some View {
        modifier(SizeCalculator(size: size))
    }
}
