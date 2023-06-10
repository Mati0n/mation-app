//
//  Zone.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation

struct Zone: Codable {
    var id: Int
    var name: String
    var image: String
    
    static func parseZones(from jsonObject: Any) -> [Zone]? {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) else {
                return nil
            }
            let decoder = JSONDecoder()
            return try? decoder.decode([Zone].self, from: jsonData)
        }
}
