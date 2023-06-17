//
//  ZonesScreen.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation
import SwiftUI

struct ZonesScreen: View {
    @ObservedObject var appState = AppState.shared
    
    var body: some View {
        NavigationView {
            List(appState.system?.zones ?? [], id: \.id) { zone in
                Button(action: {
                    print("Select currentZoneId: \(zone.id)")
                    appState.currentZoneId = zone.id
                    appState.navigateTo(destination: AnyView(SourcesScreen()))
                }) {
                    ZoneCell(zone: zone)
                }
            }
            .navigationTitle("Zones")
            .background(
                NavigationLink(destination: appState.destination, isActive: $appState.shouldNavigate) {
                    EmptyView()
                }
            )
            
            if let volumeBar = appState.currentVolumeBar {
                VolumeBarView(volumeBar: volumeBar)
            }
        }
    }
}


