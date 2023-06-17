//
//  VolumeBar.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 15.06.2023.
//

import Foundation
import SwiftUI

struct VolumeBarView: View {
    var volumeBar: VolumeBar

    var body: some View {
        VStack {
            // классический вид volumeBar с контролами громкости (можно изменять по своему усмотрению)
            Text("Volume Control")
            Text("\(volumeBar.volume)")
            Button(action: {
                // increase volume
            }) {
                Image(systemName: "speaker.wave.2.fill")
            }
        }
        .background(Color.gray.opacity(0.5))
        .cornerRadius(10)
    }
}
