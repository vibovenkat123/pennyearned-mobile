//
//  NextButtonView.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 3/12/23.
//

import SwiftUI

struct GoToButton: View {
    typealias validatingFunction = (_ text: String) -> Bool
    var destination: AnyView
    var text: String
    var imageName: String?
    init(destination: AnyView, text: String, imageName: String? = nil) {
        self.destination = destination
        self.text = text
        self.imageName = imageName
    }
    var body: some View {
        VStack {
            NavigationLink(destination: destination) {
                ButtonContent(text: text, imageName: imageName)
            }
            .foregroundColor(.white)
            .padding()
            .background(Globals.btnColor)
            .cornerRadius(10)
        }
        .padding()
    }
}
struct ButtonContent: View {
    var text: String
    var imageName: String?
    init(text: String, imageName: String?) {
        self.text = text
        self.imageName = imageName
    }
    var body: some View {
        HStack {
            Spacer()
            Text(text)
            if imageName != nil {
                Image(systemName: imageName!)
            }
            Spacer()
        }
    }
}
