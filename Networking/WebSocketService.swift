//
//  URLSessionWebSocketTask.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation
import SocketIO

class WebSocketService {
    static let shared = WebSocketService()

    private let manager: SocketManager
    private let socket: SocketIOClient

    private init() {
        manager = SocketManager(socketURL: URL(string: "http://localhost:53301")!, config: [.log(false), .compress])
        socket = manager.defaultSocket

        socket.on(clientEvent: .connect) { (_, _) in
            print("Connected to websocket server")
        }

        // Обработка любых событий, которые ваш сервер будет отправлять
        socket.on("event_from_server") { (data, _) in
            print("Received data:", data)
            if let receivedData = data[0] as? [String: Any],
               let jsonData = try? JSONSerialization.data(withJSONObject: receivedData, options: []) {
                // Работайте с полученными данными
                self.onMessageReceived(data: jsonData)
            }
        }

        socket.connect()
    }

    func sendDataToServer(eventName: String, data: [String: Any]) {
        socket.emit(eventName, data)
    }

    func onMessageReceived(data: Data) {
        do {
            // Декодирование данных в модель WebSocketMessage
            let message = try JSONDecoder().decode(WebSocketMessage.self, from: data)

            // Проверка сообщений от сервера и вызов соответствующих функций для обновления компонентов пользовательского интерфейса
            if let messageType = message.type, let messageData = message.data {
                switch messageType {
                case "zones":
                    let zones = try JSONDecoder().decode([Zone].self, from: messageData)
                    // Вызов функции обновления списка зон
                    AppState.shared.zones = zones
                case "sources":
                    let sources = try JSONDecoder().decode([Source].self, from: messageData)
                    // Вызов функции обновления списка источников
                    AppState.shared.sources = sources
                // Добавьте обработку других сообщений от сервера здесь...
                default:
                    print("Unknown message type: \(messageType)")
                }
            } else {
                print("Type or data missing in the message")
            }
        } catch {
            print("Error decoding the WebSocket message: \(error)")
        }
    }
    
    func connect() {
        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
    }
}

