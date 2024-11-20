//
//  ServerManager.swift
//  mock-telegram-app
//
//  Created by Qiwei Li on 11/14/24.
//
import Foundation
import MockTelegramKit
import Vapor

@Observable public class TelegramServerManager {
    var isStartLoading: Bool = false
    var isStopLoading: Bool = false
    var isServerRunning = false
    var serverStatus = "Server Stopped"
    var serverLogs: [String] = []

    private var app: Application?

    public init() {}

    public func startServer(host: String = "127.0.0.1", port: Int = 8080) {
        Task(priority: .background) {
            do {
                isStartLoading = true
                let env = try Environment.detect()
                app = try await Application.make(env)
                // set the hostname and port
                app?.http.server.configuration.hostname = host
                app?.http.server.configuration.port = port

                // configure routes and middleware
                try await configure(app!)

                // update status
                isServerRunning = true
                serverStatus = "Server Running on port 8080"
                addLog("Server started successfully")
                isStartLoading = false
                try await app?.execute()
            } catch {
                serverStatus = "Server Failed to Start: \(error.localizedDescription)"
                addLog("Error: \(error.localizedDescription)")
                isStartLoading = false
            }
        }
    }

    public func stopServer() async {
        isStopLoading = true
        try? await app?.asyncShutdown()
        app = nil
        isServerRunning = false
        isStopLoading = false
        serverStatus = "Server Stopped"
        addLog("Server stopped")
    }

    private func addLog(_ message: String) {
        let timestamp = DateFormatter.localizedString(
            from: Date(), dateStyle: .none, timeStyle: .medium)
        serverLogs.append("[\(timestamp)] \(message)")
    }
}
