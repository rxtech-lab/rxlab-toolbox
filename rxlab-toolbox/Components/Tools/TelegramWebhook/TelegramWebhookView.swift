//
//  TelegramWebhookView.swift
//  rxlab-toolbox
//
//  Created by Qiwei Li on 1/6/25.
//
import Common
import SwiftUI

struct TelegramWebhookView: View {
    @State private var webhook: String = ""
    @AppStorage("telegramApiKey") private var apiKey: String = ""
    @AppStorage("isUsingSecret") private var useSecret: Bool = false
    @AppStorage("telegramSecret") private var secret: String = ""

    @Environment(AlertManager.self) var alert

    @State var hasLoadedWebhookInfo = false
    @State var isLoadingWebhookInfo = false

    var body: some View {
        Form {
            Section {
                TextField("API Key", text: $apiKey)
                    .disableAutocorrection(true)
                    .onSubmit {
                        Task {
                            await loadWebhookInfo()
                        }
                    }
                if hasLoadedWebhookInfo {
                    TextField("Webhook URL", text: $webhook)
                }
            }
            if hasLoadedWebhookInfo {
                Section {
                    Toggle("Use Secret for webhook", isOn: $useSecret)
                    if useSecret {
                        TextField("Secret", text: $secret)
                    }
                }
            }
            if hasLoadedWebhookInfo {
                Button("Update webhook") {
                    Task {
                        await updateWebhook()
                    }
                }
            }
            if isLoadingWebhookInfo {
                ProgressView()
            }
        }
        .padding()
    }
}

extension TelegramWebhookView {
    func loadWebhookInfo() async {
        isLoadingWebhookInfo = true
        let url = URL(string: "https://api.telegram.org/bot\(apiKey)/getWebhookInfo")!

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            let decoder = JSONDecoder()
            let webhookInfo = try decoder.decode(TelegramWebhookInfo.self, from: data)

            webhook = webhookInfo.result.url ?? ""
            hasLoadedWebhookInfo = true

        } catch {
            print(error)
            alert.showAlert(message: error.localizedDescription)
        }
        isLoadingWebhookInfo = false
    }

    func updateWebhook() async {
        isLoadingWebhookInfo = true
        var url = URL(string: "https://api.telegram.org/bot\(apiKey)/setWebhook?url=\(webhook)")!

        if useSecret {
            url = url.appending(queryItems: [.init(name: "secret_token", value: secret)])
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            await loadWebhookInfo()
        } catch {
            alert.showAlert(message: error.localizedDescription)
        }
        isLoadingWebhookInfo = false
    }
}

#Preview {
    TelegramWebhookView()
        .frame(height: 400)
}
