//
//  URLSessionWebSocketTask.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation
import SocketIO
import Combine

class WebSocketService: ObservableObject {
    static let shared = WebSocketService()

    private let manager: SocketManager
    private let socket: SocketIOClient
    private let uuid = UUID().uuidString
    
    private var retryCount = 0
    private let maxRetryAttempts = 3

    @Published var isConnected = false
    @Published var isRegistered = false
    
    private init() {
        let connectParams: [String: Any] = ["uuid": uuid]
        manager = SocketManager(socketURL: URL(string: "http://localhost:53301")!, config: [.log(false), .compress, .connectParams(connectParams)])
        socket = manager.defaultSocket

        socket.on(clientEvent: .connect) { (_, _) in
            print("Connected to websocket server")
            self.isConnected = true
            
        }
        
        socket.on("/auth/register") { [weak self] data, ack in
            print("Registered with server")
            self?.isRegistered = true
        }
        
        // Обработка любых событий, которые ваш сервер будет отправлять
        socket.on("event_from_server") { (data, _) in
            print("Received data:", data)
//            if let receivedData = data[0] as? [String: Any],
//               let jsonData = try? JSONSerialization.data(withJSONObject: receivedData, options: []) {
//                // Работайте с полученными данными
//                self.onMessageReceived(data: jsonData)
//            }
        }

        socket.connect()
    }

    func sendDataToServer(eventName: String, data: [String: Any]) {
        print("sendDataToServer: \(data)")
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

    func disconnect() {
        socket.disconnect()
    }
    
    func connect(completion: @escaping (Result<Void, Error>) -> Void) {
        socket.on(clientEvent: .connect) { (_, _) in
            self.retryCount = 0
            completion(.success(()))
        }
        
        socket.on(clientEvent: .error) { (data, _) in
            if let error = data[0] as? Error {
                if self.retryCount < self.maxRetryAttempts {
                    self.retryCount += 1
                    print("Повторная попытка подключения #\(self.retryCount)...")
                    self.socket.connect()
                } else {
                    completion(.failure(error))
                }
            }
        }

        socket.connect()
    }

    // Добавьте функцию авторизации:
    func authenticate(completion: @escaping (Result<Void, Error>) -> Void) {
        // Замените "/auth/register" на соответствующее событие сервера
        socket.on("/auth/register") { (data, _) in
            // Вызовите completion(.success(())), если сервер сообщает об успешной авторизации
            completion(.success(()))
        }
        
        // Замените "authentication_error" на соответствующее событие сервера
        socket.on("authentication_error") { (data, _) in
            if let error = data[0] as? Error {
                completion(.failure(error))
            }
        }
    }
}

