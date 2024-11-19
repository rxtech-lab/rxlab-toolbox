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

struct RxToolboxDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.toolboxDocument] }

    var adapterData: [String: AdapterData] = [:]
    var hasInitialized: Bool = false

    init(configuration: ReadConfiguration) throws {
    }

    init() {}

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return .init(regularFileWithContents: Data())
    }
}
