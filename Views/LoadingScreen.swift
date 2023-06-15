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

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .scaleEffect(2)
            } else {
                NavigationLink(
                    destination: ZonesScreen(),
                    isActive: .constant(!isLoading),
                    label: { EmptyView() }
                )
            }
        }
        .onAppear {
            let webSocketService = AppState.shared.webSocketService
                    
            webSocketService.connect { result in
                switch result {
                case .success:
                    webSocketService.authenticate { authResult in
                        switch authResult {
                        case .success:
                            DispatchQueue.main.async {
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
