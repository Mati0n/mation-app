//
//  HandleSources.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 13.06.2023.
//

import Foundation

// Event handler "getSources"
func handleSources(data: [Any]) {
    print("Received list of sources \(data)")
    if let JSONArray = (data[0] as? NSDictionary)?["sources"] as? NSArray,
       let JSONData = try? JSONSerialization.data(withJSONObject: JSONArray, options: []) {
        do {
            let sources = try JSONDecoder().decode([Source].self, from: JSONData)
            //AppState.shared.sources = sources
        } catch {
            print("Source Decoding error: \(error)")
        }
    } else {
        print("Source Decoding error")
    }
}
