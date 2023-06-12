//
//  Zone.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation

struct ZoneResponse: Decodable {
    let zones: [Zone]
}

struct Zone: Codable, Identifiable {
    let id: String
    let name: String
    let image: String?
    let isEnabled: Bool?
    let isActive: Bool?
    let sources: [Source]?
    let volumeBar: VolumeBar?
    let floor: String?
    let space: String?
    
    //add parsing
}

struct Source: Codable {
    let id: String
    let name: String
    let isActive: Bool?
    let image: String?
    let isEnabled: Bool?
    let isVisible: Bool?
    
    //add parsing
}

struct VolumeBar: Codable {
    let mute: Bool
    let template: Int
    let visible: Bool
    let volume: Int
    
    //add parsing
}

enum ZoneError: Error {
    case missingKey(String)
}

struct Zone1: Codable, Identifiable {
    let id: String
    let name: String
    let isEnabled: Bool
    let isActive: Bool
    let sources: [Source]?
    let volumeBar: VolumeBar
    let floor: String
    let space: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, isEnabled, isActive, sources, volumeBar, floor, space
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let idValue = try? container.decode(String.self, forKey: .id) else {
            throw ZoneError.missingKey(CodingKeys.id.rawValue)
        }
        id = idValue
        
        guard let nameValue = try? container.decode(String.self, forKey: .name) else {
            throw ZoneError.missingKey(CodingKeys.name.rawValue)
        }
        name = nameValue
      
        // Для остальных ключей используйте автоматическое декодирование

        isEnabled = try container.decode(Bool.self, forKey: .isEnabled)
        isActive = try container.decode(Bool.self, forKey: .isActive)
        sources = try container.decode([Source].self, forKey: .devices)
        volumeBar = try container.decode(VolumeBar.self, forKey: .volumeBar)
        floor = try container.decode(String.self, forKey: .floor)
        space = try container.decode(String.self, forKey: .space)
    }
}
