//
//  Navigation.swift
//  mock-telegram-app
//
//  Created by Qiwei Li on 11/14/24.
//

enum NavigationPath: Hashable {
    case webhook(Webhook)
    case chatroom(Chatroom)
}
