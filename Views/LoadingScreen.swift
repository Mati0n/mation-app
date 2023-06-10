//
//  LoadingScreen.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation
import SwiftUI

struct LoadingScreen: View {
    @EnvironmentObject var webSocketService: WebSocketService
    @State private var isLoading = true
    @State private var isLoggedIn = false

    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .scaleEffect(2)
            } else {
                // Переход к ZoneScreen или другому экрану при успешной авторизации
                NavigationLink(
                    destination: ZonesScreen(),
                    isActive: $isLoggedIn,
                    label: { EmptyView() }
                )
            }
        }
        .onAppear {
            webSocketService.connect { result in
                switch result {
                case .success:
                    webSocketService.authenticate { authResult in
                        switch authResult {
                        case .success:
                            // Получение состояния системы и доп. команд здесь
                            webSocketService.sendDataToServer(eventName: "getZones", data: [:])
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                isLoading = false
                            }
                        case .failure(let error):
                            print("Ошибка авторизации: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    print("Ошибка подключения: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
    }
}
