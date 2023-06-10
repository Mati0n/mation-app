//
//  SourceDetailScreen.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation
import SwiftUI

struct SourceDetailsScreen: View {
    var source: Source

    var body: some View {
        VStack {
            Text("Details for \(source.name)")
            // Здесь добавьте кастомные элементы управления для каждого источника управления
        }
        .padding()
        .navigationTitle(source.name)
    }
}
