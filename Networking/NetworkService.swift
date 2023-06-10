//
//  NetworkService.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation
import Alamofire

class NetworkService {
    static let shared = NetworkService()

    private init() {}

    func getRequest(_ path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let data: [String: Any] = ["path": path]
        WebSocketService.shared.sendDataToServer(eventName: "get", data: data)
    }

    func postRequest(_ path: String, parameters: Parameters, completion: @escaping (Result<Data, Error>) -> Void) {
        let data: [String: Any] = ["path": path, "parameters": parameters]
        WebSocketService.shared.sendDataToServer(eventName: "post", data: data)
    }

    func putRequest(_ path: String, parameters: Parameters, completion: @escaping (Result<Data, Error>) -> Void) {
        let data: [String: Any] = ["path": path, "parameters": parameters]
        WebSocketService.shared.sendDataToServer(eventName: "put", data: data)
    }

    func deleteRequest(_ path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let data: [String: Any] = ["path": path]
        WebSocketService.shared.sendDataToServer(eventName: "delete", data: data)
    }
}
