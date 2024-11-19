//
//  Document.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/19/24.
//
import SwiftData
import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let toolboxDocument = UTType(exportedAs: "dev.rxlab.toolbox")
}

@Model
final class RxToolboxDocument {
    init() {
    }
}
