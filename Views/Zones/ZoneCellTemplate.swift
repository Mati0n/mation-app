//
//  ZoneCellTemplate.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation
import SwiftUI

struct ZoneCell: View {
    var zone: Zone

    var body: some View {
        HStack {
            Image(zone.image ?? "icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            Text(zone.name)
            Spacer()
        }
    }
}
