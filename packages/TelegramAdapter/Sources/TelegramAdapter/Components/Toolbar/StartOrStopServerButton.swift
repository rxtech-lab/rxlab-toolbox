//
//  StartOrStopServerButton.swift
//  mock-telegram-app
//
//  Created by Qiwei Li on 11/14/24.
//

import Common
import SwiftUI

/// Shows a button that can start or stop the server
struct StartOrStopServerButton: View {
    @Environment(TelegramServerManager.self) var serverManager
    @Environment(SheetManager.self) var sheetManager
    @State private var show = false
    @AppStorage("webhookHost") private var host = "0.0.0.0"
    @AppStorage("webhookPort") private var port = 8080

    let variant: ActionVariant

    func buildForm() -> some View {
        Form {
            Text("Mock Telegram Server Configuration")
                .font(.headline)
            TextField("Host", text: $host)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(serverManager.isServerRunning)
            TextField("Port", value: $port, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(serverManager.isServerRunning)
            HStack {
                Spacer()
                if !serverManager.isServerRunning {
                    Button {
                        Task {
                            serverManager.startServer(host: host, port: port)
                            show = false
                            if variant == .sidebar {
                                print("hide sheet")
                                sheetManager.hideSheet()
                            }
                        }
                    } label: {
                        if serverManager.isStartLoading {
                            ProgressView()
                        } else {
                            Text("Start")
                        }
                    }
                } else {
                    Button {
                        Task {
                            await serverManager.stopServer()
                            show = false
                            if variant == .sidebar {
                                sheetManager.hideSheet()
                            }
                        }
                    } label: {
                        if serverManager.isStopLoading {
                            ProgressView()
                        } else {
                            Text("Stop")
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder private func buildButton() -> some View {
        Group {
            if serverManager.isServerRunning {
                Button {
                    show = true
                    if variant == .sidebar {
                        sheetManager.showSheet {
                            buildForm()
                                .padding()
                                .frame(width: 300, height: 150)
                        }
                    }
                } label: {
                    if variant == .sidebar {
                        Image(systemName: "stop.fill")
                    } else {
                        Label("Stop server", systemImage: "stop.fill")
                    }
                }
                .help("Stop the server")
            } else {
                Button {
                    show = true
                    if variant == .sidebar {
                        sheetManager.showSheet {
                            buildForm()
                                .padding()
                                .frame(width: 300, height: 150)
                        }
                    }
                } label: {
                    if variant == .sidebar {
                        Image(systemName: "play.fill")
                    } else {
                        Label("Start server", systemImage: "play.fill")
                    }
                }
                .help("Start the server")
            }
        }
    }

    var body: some View {
        if variant == .toolbar {
            buildButton()
                .popover(isPresented: $show) {
                    buildForm()
                        .padding()
                        .frame(width: 300, height: 150)
                }
        } else {
            buildButton()
                .buttonStyle(.borderless)
        }
    }
}
