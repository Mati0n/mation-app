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
    @Published var hasLoadedZones = false
    
    private init() {
        let connectParams: [String: Any] = ["uuid": uuid]
        manager = SocketManager(socketURL: URL(string: "http://localhost:53301")!, config: [.log(false), .compress, .connectParams(connectParams)])
        socket = manager.defaultSocket

        socket.on(clientEvent: .connect) { (_, _) in
            print("Connected to websocket server")
            self.isConnected = true
            
        }
        
        socket.on("registration") { [weak self] data, ack in
            print("Registered with server")
            self?.isRegistered = true
            //self?.sendDataToServer(eventName: "/api/v1/zones", data: [:])
            self?.socket.emit("getZones", [] as [Any])
        }
        
        socket.on("updateUI") { [weak self] data, ack in
            print("Received UI update! \(data)")
            
            //self?.hasLoadedZones = true
            // Process the list of zones here
            // Преобразуйте полученные данные
                if let jsonString = data.first as? String,
                   let jsonData = jsonString.data(using: .utf8) {
                    do {
                        let decoder = JSONDecoder()
                        let zones = try decoder.decode([Zone].self, from: jsonData)
                        // передать zones в интерфейс
                        AppState.shared.zones = zones
                    } catch {
                        print("Ошибка декодирования: \(error.localizedDescription)")
                    }
                }
        }
        
        connect{_ in}
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
            self.isRegistered = true
        }
        
        // Замените "authentication_error" на соответствующее событие сервера
        socket.on("authentication_error") { (data, _) in
            if let error = data[0] as? Error {
                completion(.failure(error))
            }
        }
    }
}

