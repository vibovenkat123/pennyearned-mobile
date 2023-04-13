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
                .foregroundColor(.primary)
            } else {
                SecureField(
                    placeholder,
                    text: text
                )
                .foregroundColor(.primary)
            }
            Divider()
                .frame(height: 1)
                .padding(.horizontal, 30)
                .background(.primary)
        }
        .padding(.bottom, 60)
    }
}
