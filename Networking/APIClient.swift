//
//  APIClient.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation
import Alamofire

class APIClient {
    // MARK: - Zone API
    static func getZones(completion: @escaping (Result<[Zone], AFError>) -> Void) {
        WebSocketService.shared.sendDataToServer(eventName: "getZones", data: [:])
    }
        
    // MARK: - Sources API
    static func getSources(completion: @escaping (Result<[Source], AFError>) -> Void) {
        WebSocketService.shared.sendDataToServer(eventName: "getSources", data: [:])
    }
    
    // добавьте остальные методы здесь ...
}

