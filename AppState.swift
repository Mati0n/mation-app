//
//  AppState.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation
import SwiftUI
//import Combine

class AppState: ObservableObject {
    static let shared = AppState()
    @Published var currentZoneId: String?
    @Published var currentSourceId: String?
    @Published var system: System?
    //@Published var zones: [Zone] = []
    //@Published var sources: [Source] = []
    @Published var currentVolumeBar: VolumeBar?
    @Published var shouldNavigate = false
    @Published var destination: AnyView?
    var webSocketService: WebSocketService
    //private var cancellables = Set<AnyCancellable>()
    
    
    private init() {
        webSocketService = WebSocketService.shared
    }
    
    func updateZones() {
        webSocketService.sendDataToServer(eventName: "getZones")
    }
    
    func requestSystemConfig() {
        webSocketService.sendDataToServer(eventName: "getSystemConfig")
    }
    
    var currentZoneSources: [Source] {
        guard let zone = system?.zones.first(where: { $0.id == currentZoneId }),
              let zoneSourcesIds = zone.sources,
              let allSources = system?.sources else {
            return []
        }
        
        let zoneSources = allSources.filter { source in
            zoneSourcesIds.contains { sourceId in
                return "\(sourceId)" == "\(source.id)"
            }
        }
        
        return zoneSources
    }

    // Функция для осуществления навигации
    func navigateTo(destination: AnyView) {
        self.destination = destination
        shouldNavigate = true
    }

}
