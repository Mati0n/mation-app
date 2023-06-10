//
//  AppState.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    static let shared = AppState()
    @Published var currentZoneId: String?
    @Published var currentSourceId: String?
    @Published var zones: [Zone] = []
    @Published var sources: [Source] = []
    
    private var webSocketService: WebSocketService

    private init() {
        webSocketService = WebSocketService.shared
    }
}
/**
 Когда вы создадите экран с сохранением выбранной зоны и источника, вы можете использовать менять `currentZoneId` и `currentSourceId` следующим образом:

 ```swift
 AppState.shared.currentZoneId = selectedZoneId
 AppState.shared.currentSourceId = selectedSourceId
 ```

 Для того чтобы получить доступ к значениям currentZoneId и currentSourceId используйте:

 ```swift
 let currentZoneId = AppState.shared.currentZoneId
 let currentSourceId = AppState.shared.currentSourceId
 ```
 */
