//
//  EmailInput.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 3/12/23.
//

import SwiftUI

struct FormInputField: View {
    var text: Binding<String>
    var placeholder: String
    var secure: Bool
    init(text: Binding<String>, placeholder: String, secure: Bool) {
        self.text = text
        self.placeholder = placeholder
        self.secure = secure
    }
    var body: some View {
        VStack{
            if !secure {
                TextField(
                    placeholder,
                    text: text
                )
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.primary, lineWidth: 3)
                        .padding(.bottom, 3)
                        .padding(.leading, 6)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                )
                .foregroundColor(.primary)
            } else {
                SecureField(
                    placeholder,
                    text: text
                )
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.primary, lineWidth: 3)
                        .padding(.bottom, 3)
                        .padding(.leading, 6)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                )
                .foregroundColor(.primary)
            }
        }
        .padding(.bottom, 60)
    }
}
