//
//  CustomButton.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 4/20/23.
//

import SwiftUI


struct RoundedButtonStyle: ButtonStyle {
    var borderWidth: CGFloat = 3
    var cornerRadius: CGFloat = 10
    var borderColor: Color = .primary
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
                    .padding(.bottom, borderWidth)
                    .padding(.leading, borderWidth * 2)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            )
            .foregroundColor(borderColor)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

