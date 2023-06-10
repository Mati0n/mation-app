//
//  Source.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation

struct Source: Codable {
    var id: Int
    var name: String
    
    static func parseSources(from jsonObject: Any) -> [Source]? {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) else {
                return nil
            }
            let decoder = JSONDecoder()
            return try? decoder.decode([Source].self, from: jsonData)
        }
}
