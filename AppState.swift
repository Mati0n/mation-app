//
//  AppState.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation
import SwiftUI
import Combine

class AppState: ObservableObject {
    static let shared = AppState()
    @Published var currentZoneId: String?
    @Published var currentSourceId: String?
    @Published var system: System?
    @Published var zones: [Zone] = []
    @Published var sources: [Source] = []
    var webSocketService: WebSocketService
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        webSocketService = WebSocketService.shared
    }
    
    func updateZones() {
        webSocketService.sendDataToServer(eventName: "getZones")
    }
    
    func requestSystemConfig() {
        webSocketService.sendDataToServer(eventName: "getSystemConfig")
    }
}
