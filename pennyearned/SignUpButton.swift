//
//  SignUpButton.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 3/9/23.
//

import SwiftUI
func SignUp() {
    // TODO: ADD THE SIGN UP LOGIC
}
struct SignUpButton: View {
    var body: some View {
        Button(action: SignUp) {
            Text("Sign Up")
        }
        .foregroundColor(.white)
        .padding()
        .background(Color(red: 0.06274509803921569, green: 0.5215686274509804, blue: 0.8549019607843137))
        .cornerRadius(10)
    }
}

struct SignUpButton_Previews: PreviewProvider {
    static var previews: some View {
        SignUpButton()
    }
}
