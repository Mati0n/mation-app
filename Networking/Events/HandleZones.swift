//
//  HandleZones.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 13.06.2023.
//

import Foundation

// Event handler "getZones"
func handleZones(data: [Any]) {
    print("Received list of zones:  \(data)")
    if let JSONArray = (data[0] as? NSDictionary)?["zones"] as? NSArray,
       let JSONData = try? JSONSerialization.data(withJSONObject: JSONArray, options: []) {
        do {
            let zones = try JSONDecoder().decode([Zone].self, from: JSONData)
            AppState.shared.zones = zones
        } catch {
            print("Zone Decoding error: \(error)")
        }
    } else {
        print("Zone Decoding error")
    }
}
