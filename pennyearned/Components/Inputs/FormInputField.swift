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
    init(text: Binding<String>, placeholder: String) {
        self.text = text
        self.placeholder = placeholder
    }
    var body: some View {
        VStack{
            TextField(
                placeholder,
                text: text
            )
            .foregroundColor(.primary)
            Divider()
                .frame(height: 1)
                .padding(.horizontal, 30)
                .background(.primary)
        }
        .padding(.bottom, 60)
    }
}
