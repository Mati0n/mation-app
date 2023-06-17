//
//  ContentView.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var isBootScreenVisible = true
    @ObservedObject var appState = AppState.shared

    var body: some View {
        ZStack {
            MainScreen()
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    appState.requestSystemConfig()
                }
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct MainScreen: View {
    @State private var isZonesScreenVisible = true
    @State private var isSourcesScreenVisible = false
    @State private var selectedZoneId: String?
    @State private var selectedSourceId: String?
    @State private var visibleVolumeBar: VolumeBar?

    @ObservedObject var appState = AppState.shared

    var body: some View {
        ZStack {
            if isZonesScreenVisible {
                ZonesScreen()
            } else if isSourcesScreenVisible {
                SourcesScreen()
            }

            if let volumeBar = visibleVolumeBar {
                VolumeBarView(volumeBar: volumeBar)
            }
        }
        .onChange(of: appState.currentZoneId) { newZoneId in
            if let newZoneId = newZoneId, let newZone = appState.system?.zones.first(where: { $0.id == newZoneId }) {
                if isZonesScreenVisible {
                    visibleVolumeBar = newZone.volumeBar
                }
            }
        }
    }
}
