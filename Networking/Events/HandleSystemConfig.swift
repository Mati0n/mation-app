//
//  HandleSystemConfig.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 13.06.2023.
//

import Foundation

func handleSystemConfig(data: [Any]) {
    print("Received systemConfig:  \(data)")
    if let jsonObject = data[0] as? [String: Any],
       let JSONData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) {
        do {
            let system = try JSONDecoder().decode(System.self, from: JSONData)
            AppState.shared.system = system
            print("AppState.shared.system: \(system)")
        } catch {
            print("SystemConfig Decoding error: \(error)")
        }
    } else {
        print("SystemConfig Decoding error")
    }
}
