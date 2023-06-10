//
//  SceneDelegate.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation
import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let webSocketService = WebSocketService.shared
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Создать экземпляр AppState
        let appState = AppState.shared

        

        // Создать представление ContentView и установить AppState в качестве входного параметра
        let contentView = ContentView().environmentObject(appState)

        // Использовать представление ContentView в качестве корневого представления для окна
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Отключить WebSocket при переходе приложения в неактивное состояние
        webSocketService.disconnect()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Не отключать WebSocket при переходе приложения в фоновый режим
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Восстановить соединение с WebSocket, когда приложение возвращается на передний план
        webSocketService.connect{_ in}
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Восстановить соединение с WebSocket, когда приложение становится активным
        webSocketService.connect{_ in}
    }

    // ...ограничений связанных с использованием окон браузера и ошибок

}
