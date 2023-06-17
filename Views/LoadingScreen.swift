//
//  LoadingScreen.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation
import SwiftUI

struct LoadingScreen: View {
    @State private var isLoading = true
    var onComplete: () -> Void

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                .scaleEffect(2)
            } else {
                EmptyView()
                //.onAppear(perform: onComplete) // переместим вызов onComplete сюда
            }
        }
        .onAppear {
            let webSocketService = AppState.shared.webSocketService
            
            if !isLoading {
                onComplete()
            }
            
            webSocketService.connect { result in
                switch result {
                case .success:
                    webSocketService.authenticate { authResult in
                        switch authResult {
                        case .success:
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
