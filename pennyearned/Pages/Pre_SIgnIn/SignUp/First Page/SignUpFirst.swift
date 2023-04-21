//  SignUpView.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 3/12/23.
//

import SwiftUI
struct FirstSignUpPage: View {
    @State var nextPage: Bool = false
    @State var email: String = ""
    var body: some View {
        if nextPage {
            SecondSignUpPage(email: email)
        } else {
            SignUpFirstPage(email: $email, nextPage: $nextPage)
        }
    }
}
struct SignUpFirstPage: View {
    @Binding var email: String
    @State private var showAlert: Bool = false
    @Binding var nextPage: Bool
    var body: some View {
        NavigationStack {
            VStack{
                FormInputField(text: $email, placeholder: "Email", secure: false)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                    .frame(minWidth: 0, maxWidth: .infinity)
                Button() {
                    validateEmail(email: email) {res in
                        switch res {
                        case .Good:
                            nextPage = true
                        case .BadEmail:
                            showAlert = true
                        }
                    }
                } label: {
                    Text("Verify Email")
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                .buttonStyle(RoundedButtonStyle())
            }
            .padding(.leading, 60)
            .padding(.trailing, 60)
            
            GoToButton(destination: AnyView(
                SignInPage()
            ), text: "Sign in")
            .padding(.leading, 60)
            .padding(.trailing, 60)
            .padding(.top, 100)
            .alert("Email is invalid", isPresented: $showAlert) {
            }
        }
    }

}

