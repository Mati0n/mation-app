//
//  Zone.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation

struct System: Codable {
    let navbar: [NavBar]?
    let zones: [Zone]
    let sources: [Source]?
}

struct Zone: Codable, Identifiable {
    let id: String
    let name: String
    let image: String?
    let isEnabled: Bool?
    let isActive: Bool?
    let sources: [String]?
    let volumeBar: VolumeBar?
    let floor: String?
    let space: String?

}

struct Source: Codable {
    let id: String
    let name: String
    let isActive: Bool?
    let image: String?
    let isEnabled: Bool?
    let isVisible: Bool?
}

struct VolumeBar: Codable {
    let mute: Bool
    let template: Int
    let visible: Bool
    let volume: Int
}

struct NavBar: Codable {
    let header: String
}
