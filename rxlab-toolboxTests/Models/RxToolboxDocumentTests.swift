//
//  RxToolboxDocumentTests.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 11/21/24.
//
import Foundation
import MockTelegramKit
@testable import rxlab_toolbox
import TelegramAdapter
import Testing

struct RxToolboxDocumentTests {
    let message = Message(messageId: 1, text: "Hello world", userId: .BotUserId)
    let webhook = Webhook(chatroomId: 1, url: .init(string: "https://google.com")!)

    @Test func encodeAndDecodeTelegramAdapterData() async throws {
        let encodingData = TelegramAdapterData(messages: [1: [message]], webhooks: [1: webhook], messageId: 1, chatroomId: 1)
        var document = RxToolboxDocument()
        document.adapterData = [.telegram: encodingData]
        let encodedData = try JSONEncoder().encode(document)
        let decodedDocument = try JSONDecoder().decode(RxToolboxDocument.self, from: encodedData)
        let decodedData = decodedDocument.adapterData[.telegram] as! TelegramAdapterData

        #expect(encodingData == decodedData, .init(stringLiteral: "Decoded data should be the same as encoded data"))
    }
}
