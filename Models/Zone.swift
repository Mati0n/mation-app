//
//  Zone.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation

struct Zone: Codable, Identifiable {
    let id: String
    let image: String
    let isEnabled: Bool
    let isActive: Bool
    let name: String
    let devices: [Device]
    let volumeBar: VolumeBar
    let floor: String
    let space: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case image, isEnabled, isActive, name, devices, volumeBar, floor, space
    }
}

struct Device: Codable {
    let id: String
    let isEnabled: Bool
    let isActive: Bool
    let isVisible: Bool
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case isEnabled, isActive, name, isVisible
    }
}

struct VolumeBar: Codable {
    let mute: Bool
    let template: Int
    let visible: Bool
    let volume: Int
}
