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
            List(zones, id: \.id) { zone in
                ZoneCell(zone: zone)
            }
            .onAppear(perform: loadZones)
            .navigationTitle("Zones")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Failed to load zones data."), dismissButton: .default(Text("OK")))
            }
        }
    }

    func loadZones() {
//        appState.updateZones() { result in
//            switch result {
//            case .success(let zones):
//                self.updateZones(zones: zones)
//            case .failure(let error):
//                // обработайте ошибку здесь, например, отобразите сообщение об ошибке
//                print("Error: \(error.localizedDescription)")
//                self.showAlert = true
//            }
//        }
    }
}

extension ZonesScreen {
    func updateZones(zones: [Zone]) {
        DispatchQueue.main.async {
            appState.zones = zones
        }
    }
}
