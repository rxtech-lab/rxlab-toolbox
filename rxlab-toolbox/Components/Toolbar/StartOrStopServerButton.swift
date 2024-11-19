//
//  StartOrStopServerButton.swift
//  mock-telegram-app
//
//  Created by Qiwei Li on 11/14/24.
//

import SwiftUI

/// Shows a button that can start or stop the server
struct StartOrStopServerButton: View {
    @Environment(ServerManager.self) var serverManager
    @State private var showStartServerPopover = false
    @State private var showStopServerPopover = false
    @AppStorage("webhookHost") private var host = "0.0.0.0"
    @AppStorage("webhookPort") private var port = 8080

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
                            await serverManager.startServer(host: host, port: port)
                            showStartServerPopover = false
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
                            showStopServerPopover = false
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

    var body: some View {
        Group {
            if serverManager.isServerRunning {
                Button {
                    showStopServerPopover = true
                } label: {
                    Label("Stop Server", systemImage: "stop.fill")
                }
                .help("Stop the server")
                .popover(isPresented: $showStopServerPopover) {
                    buildForm()
                        .padding()
                        .frame(width: 300, height: 150)
                }
            } else {
                Button {
                    showStartServerPopover = true
                } label: {
                    Label("Start Server", systemImage: "play.fill")
                }
                .help("Start the server")
                .popover(isPresented: $showStartServerPopover) {
                    buildForm()
                        .padding()
                        .frame(width: 300, height: 150)
                }
            }
        }
    }
}

#Preview {
    StartOrStopServerButton()
}
