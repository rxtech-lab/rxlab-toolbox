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

    enum CodingKeys: String, CodingKey {
        case url
        case pendingUpdateCount = "pending_update_count"
        case lastErrorDate = "last_error_date"
        case lastErrorMessage = "last_error_message"
        case maxConnections = "max_connections"
        case ipAddress = "ip_address"
    }
}
