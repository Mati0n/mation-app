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
    @State private var zones: [Zone] = []
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            List(appState.zones, id: \.id) { zone in
                ZoneCell(zone: zone)
                .onTapGesture {
                    appState.currentZoneId = zone.id
                    WebSocketService.shared.sendDataToServer(eventName: "selectZone", data: ["id": zone.id])
                }
            }
            .onAppear(perform: loadZones)
            .navigationTitle("Zones")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Failed to load zones data."), dismissButton: .default(Text("OK")))
            }
        }
    }

    func loadZones() {
        appState.updateZones()
    }
}
