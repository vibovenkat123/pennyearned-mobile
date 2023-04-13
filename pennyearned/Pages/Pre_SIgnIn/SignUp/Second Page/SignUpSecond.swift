//
//  SIgnUpSecondPage.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 3/12/23.
//

import SwiftUI
import Combine
struct SignUpReq {
    var email: String
    var password: String
    var username: String
    init(email: String, password: String, username: String) {
        self.email = email
        self.password = password
        self.username = username
    }
}
struct SecondSignUpPage: View {
    @State private var code: String = "123456"
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var pwdBad: Bool = false
    @State private var usernameBad: Bool = false
    @State private var codeBad: Bool = false
    var email: String
    init(email: String) {
        self.email = email
    }
    var body: some View {
        NavigationStack {
            VStack{
                FormInputField(text: $code, placeholder: "Verification Code", secure: false)
                    .keyboardType(.numberPad)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .onReceive(Just(code)) { newCode in
                        let filtered = newCode.filter { "0123456789".contains($0) }
                        if filtered != code {
                            self.code = filtered
                        }
                    }
                    .onReceive(Just(code)) { _ in
                        if code.count > 6 {
                            code = String(code.prefix(6))
                        }
                    }
                FormInputField(text: $username, placeholder: "Username", secure: false)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .textContentType(.username)
                    .onReceive(Just(username)) { _ in
                        if username.count > 12 {
                            username = String(username.prefix(12))
                        }
                    }
                
                FormInputField(text: $password, placeholder: "Password", secure: true)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .textContentType(.password)
                    .onReceive(Just(password)) { _ in
                        if password.count > 20 {
                            password = String(password.prefix(20))
                        }
                    }
                Button("Sign Up") {
                    if !validateCode(code: code) {
                       codeBad = true
                    } else if !validatePwd(password: password) {
                        pwdBad = true
                    } else if !validateUsername(username: username) {
                        usernameBad = true
                    }
                }
                .alert("Password must be at least 8 and less than or equal to 20 characters",
                  isPresented: $pwdBad) {
                }
                .alert("Code must be 6 characters",
                  isPresented: $codeBad) {
                }
                .alert("Username must be greater than 2 and less than 12 characters",
                  isPresented: $usernameBad) {
                }
            }
            .padding(.leading, 60)
            .padding(.trailing, 60)
        }
    }
}


