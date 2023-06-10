//
//  APIClient.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation
import Alamofire

class APIClient {
    // Сюда можно вставить ваш адрес сервера или загрузить его из настроек приложения
    static let baseURL = "http://localhost:53301/api/v1"
    
    // MARK: - Zone API
    static func getZones(completion: @escaping (Result<[Zone], AFError>) -> Void) {
//        AF.request("\(baseURL)/zones", method: .get).validate().responseDecodable(of: [Zone].self) { response in
//            completion(response.result)
//        }
        WebSocketService.shared.sendDataToServer(eventName: "get_zones", data: [:])
    }
    
    // добавьте остальные методы для Zones API здесь ...
    
    // MARK: - Sources API
    static func getSources(completion: @escaping (Result<[Source], AFError>) -> Void) {
//        AF.request("\(baseURL)/sources", method: .get).validate().responseDecodable(of: [Source].self) { response in
//            completion(response.result)
//        }
        WebSocketService.shared.sendDataToServer(eventName: "get_sources", data: [:])
    }
    
    // добавьте остальные методы для Sources API здесь ...
}

