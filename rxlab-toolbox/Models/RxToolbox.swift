//
//  Document.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/19/24.
//
import AnyCodable
import Common
import SwiftData
import SwiftUI
import TelegramAdapter
import TestKit
import UniformTypeIdentifiers

extension UTType {
    static let toolboxDocument = UTType(exportedAs: "dev.rxlab.toolbox")
}

enum DecodingError: LocalizedError {
    case decodingError

    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "Error decoding data"
        }
    }
}

struct RxToolboxDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.toolboxDocument] }

    var adapterData: [AvailableAdapters: any AdapterData] = [:]
    var hasInitialized: Bool = false
    var adapters: [AvailableAdapters] = []
    var testPlans: [TestPlan] = []

    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            let decoder = JSONDecoder()
            self = try decoder.decode(Self.self, from: data)
        }
    }

    init() {}

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return .init(regularFileWithContents: data)
    }
}

extension RxToolboxDocument: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hasInitialized = try container.decode(Bool.self, forKey: .hasInitialized)
        adapters = try container.decode([AvailableAdapters].self, forKey: .adapters)
        testPlans = try container.decode([TestPlan].self, forKey: .testPlans)
        let rawAdapterData = try container.decode([AvailableAdapters: String].self, forKey: .adapterData)
        adapterData = try rawAdapterData.mapValues { data in
            if let data = Data(base64Encoded: data) {
                if let telegramData = try? JSONDecoder().decode(TelegramAdapterData.self, from: data) {
                    return telegramData
                }
            }
            throw DecodingError.decodingError
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hasInitialized, forKey: .hasInitialized)
        try container.encode(adapters, forKey: .adapters)
        try container.encode(testPlans, forKey: .testPlans)
        let rawData = try adapterData.mapValues { adapter -> Data in
            try JSONEncoder().encode(adapter)
        }
        try container.encode(rawData, forKey: .adapterData)
    }

    enum CodingKeys: CodingKey {
        case hasInitialized
        case adapters
        case adapterData
        case testPlans
    }
}
