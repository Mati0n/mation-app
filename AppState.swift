//
//  AppState.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation
import SwiftUI
import Combine
import UIKit

class AppState: ObservableObject {
    static let shared = AppState()
    @Published var currentZoneId: String?
    @Published var currentSourceId: String?
    @Published var zones: [Zone] = []
    @Published var sources: [Source] = []
    private(set) lazy var hwid: String = getHWID()
    private var webSocketService: WebSocketService
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        webSocketService = WebSocketService.shared
    }
    
    private func getHWID() -> String {
        if let id = UIDevice.current.identifierForVendor {
            return id.uuidString
        }
        return "Failed to get hwid"
    }
    
    func updateZones() {
        webSocketService.sendDataToServer(eventName: "getZones")
    }
}
