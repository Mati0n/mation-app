//
//  SourcesScreen.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation
import SwiftUI

struct SourcesScreen: View {
    @State private var sources: [Source] = []
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            List(sources, id: \.id) { source in
                NavigationLink(destination: SourceDetailsScreen(source: source)) {
                    Text(source.name)
                }
            }
            .onAppear(perform: loadSources)
            .navigationTitle("Sources")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Failed to load sources data."), dismissButton: .default(Text("OK")))
            }
        }
    }

    func loadSources() {
        APIClient.getSources { result in
            switch result {
            case .success(let sources):
                self.updateSources(sources: sources)
            case .failure(let error):
                // обработайте ошибку здесь, например, отобразите сообщение об ошибке
                print("Error: \(error.localizedDescription)")
                self.showAlert = true
            }
        }
    }
}

extension SourcesScreen {
    func updateSources(sources: [Source]) {
        DispatchQueue.main.async {
            self.sources = sources
        }
    }
}
