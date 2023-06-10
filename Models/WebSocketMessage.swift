//
//  WebSocketMessage.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation

struct WebSocketMessage: Decodable {
    let type: String?
    let data: Data?
}
