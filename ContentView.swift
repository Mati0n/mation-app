//
//  ContentView.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LoadingScreen()
        .environmentObject(WebSocketService.shared)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //ContentView()
        //SourcesScreen()
        //ZonesScreen()
        LoadingScreen()
    }
}
