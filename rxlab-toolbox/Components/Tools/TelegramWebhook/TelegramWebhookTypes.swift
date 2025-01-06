//
//  TelegramWebhookTypes.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 1/6/25.
//

struct TelegramWebhookInfo: Codable {
    let ok: Bool
    let result: WebhookInfo
}

struct WebhookInfo: Codable {
    let url: String?
    let pendingUpdateCount: Int?
    let lastErrorDate: Int?
    let lastErrorMessage: String?
    let maxConnections: Int?
    let ipAddress: String?
}
