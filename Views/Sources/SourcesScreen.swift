//
//  SourcesScreen.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation
import SwiftUI

struct SourcesScreen: View {
    @ObservedObject var appState = AppState.shared
        
    var body: some View {
        NavigationView {
            List(appState.currentZoneSources, id: \.id) { source in
                NavigationLink(destination: SourceDetailsScreen(source: source)) {
                    Text(source.name)
                }
            }
            .navigationTitle("Sources")
        }
    }
}
