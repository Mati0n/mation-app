//
//  WebSocketService.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation
import SocketIO
import Combine
import UIKit

class WebSocketService: ObservableObject {

    static let shared = WebSocketService(uuid: getHWID())
    private let manager: SocketManager
    private let socket: SocketIOClient
    private let uuid: String
    
    private var retryCount = 0
    private let maxRetryAttempts = 3

    @Published var isConnected = false
    @Published var isRegistered = false
    
    let eventHandlers: [String: ([Any]) -> Void] = [
        "getSystemConfig": handleSystemConfig,
        "getZones": handleZones,
        "getSources": handleSources
    ]

    init(uuid: String) {
        self.uuid = uuid
        let connectParams: [String: Any] = ["uuid": uuid]
        manager = SocketManager(socketURL: URL(string: "http://localhost:53301")!, config: [.log(false), .compress, .connectParams(connectParams)])
        socket = manager.defaultSocket

        // Instance setup
        socket.onAny { event in
            //print("Received event: \(event.event), with items: \(event.items ?? [])")
            if let handler = self.eventHandlers[event.event] {
                print("Received event: \(event.event)")
                handler(event.items ?? [])
            } else {
                print("No event in handlers: \(event.event)")
            }
        }
        
        socket.on(clientEvent: .connect) { (_, _) in
            print("Connected to MATION server!")
            self.isConnected = true
        }
        
        connect{_ in}
    }
    
    private static func getHWID() -> String {
        if let id = UIDevice.current.identifierForVendor {
            print("getHWID: \(id.uuidString)")
            return id.uuidString
        }
        return "Failed to get hwid"
    }

    func sendDataToServer(eventName: String, data: [String: Any] = [:]) {
        print("sendDataToServer: \(eventName): \(data)")
        socket.emit(eventName, data)
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

    func authenticate(completion: @escaping (Result<Void, Error>) -> Void) {
        socket.on("registration") { (data, _) in
            completion(.success(()))
            self.isRegistered = true
            AppState.shared.requestSystemConfig()
        }
        
        socket.on("registration_error") { (data, _) in
            if let error = data[0] as? Error {
                completion(.failure(error))
            }
        }
    }
}

