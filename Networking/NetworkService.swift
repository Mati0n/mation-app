//
//  NetworkService.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation
import Alamofire
import SocketIO

class NetworkService {
    static let shared = NetworkService()

    private let baseURL: String = "http://localhost:53301/api" // замените на ваш адрес сервера

    private init() {}

    func getRequest(_ path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = "\(baseURL)/\(path)"

        AF.request(url).validate().responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func postRequest(_ path: String, parameters: Parameters, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = "\(baseURL)/\(path)"

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func putRequest(_ path: String, parameters: Parameters, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = "\(baseURL)/\(path)"

        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func deleteRequest(_ path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = "\(baseURL)/\(path)"

        AF.request(url, method: .delete, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
