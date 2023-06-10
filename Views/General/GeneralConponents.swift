//
//  GeneralConponents.swift
//  mation-ios-app
//
//  Created by Dmitry Ryzhkov on 10.06.2023.
//

import Foundation
import SwiftUI

struct PrimaryButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
}

struct CustomTextField: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
        TextField(placeholder, text: $text)
            .padding(10)
            .background(Color(.systemGray5))
            .cornerRadius(8)
            .padding(.horizontal)
    }
}

struct CustomToggle: View {
    @Binding var isOn: Bool
    var label: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.horizontal)
    }
}

struct SampleView: View {
    @State private var text: String = ""
    @State private var toggleValue: Bool = false
    
    var body: some View {
        VStack {
            CustomTextField(text: $text, placeholder: "Enter something")
            PrimaryButton(title: "Click me!") {
                print("Hello, World!")
            }
            .padding()
            CustomToggle(isOn: $toggleValue, label: "Custom toggle:")
        }
    }
}

struct CustomSlider: View {
    @Binding var value: Double
    var minValue: Double
    var maxValue: Double

    var body: some View {
        Slider(value: $value, in: minValue...maxValue)
            .padding(.horizontal)
    }
}

struct CustomStepper: View {
    @Binding var value: Int
    var minValue: Int
    var maxValue: Int
    var label: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Stepper("\(value)", value: $value, in: minValue...maxValue)
                .labelsHidden()
        }
        .padding(.horizontal)
    }
}

struct CustomProgressView: View {
    var value: Float
    var maxValue: Float

    var body: some View {
        ProgressView("", value: value, total: maxValue)
            .padding(.horizontal)
    }
}
