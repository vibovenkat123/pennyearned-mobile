//
//  SignInView.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 3/12/23.
//

import SwiftUI
    
struct SignInPage: View {
    @State var onThis: Bool = true
    var body: some View {
        if onThis {
            ThisView(onThis: $onThis)
        } else {
            MainPage(user: Globals.user)
        }
    }
}
struct ThisView: View {
    @State private var invalid: Bool = false
    @State private var username: String = ""
    @State private var password: String = ""
    @Binding var onThis: Bool
    var body: some View {
        NavigationStack {
            VStack {
                FormInputField(text: $username, placeholder: "Username", secure: false)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .textContentType(.username)
                        .frame(minWidth: 0, maxWidth: .infinity)
                
                FormInputField(text: $password, placeholder: "Password", secure: true)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .textContentType(.password)
                        .frame(minWidth: 0, maxWidth: .infinity)
                Button() {
                    Globals.keychain["password"] = password
                    Globals.keychain["username"] = username
                    SignIn(username: username, password: password) { res in
                        switch res {
                        case .notFound:
                            print("ok")
                            invalid = true
                        case .good(let user):
                            Globals.user = user
                            onThis = false
                            invalid = false
                        }
                    }
                } label: {
                    Text("Sign In")
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                .buttonStyle(RoundedButtonStyle())
                .alert("Incorrect username or password",
                       isPresented: $invalid) {
                }
            }
        }
        .padding(.leading, 60)
        .padding(.trailing, 60)
    }
}
