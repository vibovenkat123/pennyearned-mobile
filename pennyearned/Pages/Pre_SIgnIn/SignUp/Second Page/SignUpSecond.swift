//
//  SIgnUpSecondPage.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 3/12/23.
//

import SwiftUI
import Combine
struct Credentials {
    var email: String
    var username: String
    var password: String
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}


struct SecondSignUpPage: View {
    @State private var showingThis: Bool = true
    @State private var completed: Bool = false
    var email: String
    init(email: String) {
        self.email = email
    }
    var body: some View {
        VStack {
            if completed {
                MainPage(user: Globals.user)
                    .navigationBarBackButtonHidden(true)
            } else {
                if showingThis {
                    ThisPage(completed: $completed, email: email)
                } else {
                    FirstSignUpPage(emailBad: true)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
        .onAppear(perform: {
            showingThis = validateEmail(email: email)
        })
    }
}


struct ThisPage: View {
    @State private var code: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var pwdBad: Bool = false
    @State private var usernameBad: Bool = false
    @State private var codeBad: Bool = false
    @State private var codeNotFound: Bool = false
    @State private var usernameAlreadyFound: Bool = false
    @State private var msgThere: Bool = false
    @State private var msgVal: String = "no msg"
    @Binding var completed: Bool
    var email: String
    
    var body: some View {
        NavigationStack {
            VStack{
                FormInputField(text: $code, placeholder: "Code (check inbox or spam/junk)", secure: false)
                    .keyboardType(.numberPad)
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
                Button() {
                    if !validateCode(code: code) {
                        codeBad = true
                    } else if !validatePwd(password: password) {
                        pwdBad = true
                    } else if !validateUsername(username: username) {
                        usernameBad = true
                    } else {
                        let credentials = Credentials(email: email, username: username, password: password)
                        finishSignup(credentials: credentials, code: code) { res in
                            switch res {
                            case .invalidCode:
                               codeNotFound = true
                            case .usernameAlrFound:
                                usernameAlreadyFound = true
                            case .msg(let val):
                                msgThere = true
                                msgVal = val
                            case .misc:
                                break
                            case .good:
                                SignIn(username: username, password: password) {res in
                                    switch res {
                                    case .notFound:
                                        break
                                    case .good(let user):
                                        Globals.user = user
                                        completed = true
                                    }
                                }
                            }
                        }
                    }
                } label: {
                    Text("Sign Up")
                        .padding()
                        .padding(.leading, 60)
                        .padding(.trailing, 60)
                    
                }
                .background(Globals.btnColor)
                .foregroundColor(.white)
                .cornerRadius(10)
                .alert("Password must be at least 8 and less than or equal to 20 characters",
                       isPresented: $pwdBad) {
                }
                       .alert("Code must be 6 characters",
                              isPresented: $codeBad) {
                       }
                              .alert("Username must be greater than 2 and less than 12 characters",
                                     isPresented: $usernameBad) {
                              }
                                     .alert("Code is not found",
                                            isPresented: $codeNotFound) {
                                     }
                                            .alert("Username/Email is already found",
                                                   isPresented: $usernameAlreadyFound) {
                                            }
                                                   .alert("\(msgVal)", isPresented: $msgThere) {}
            }
            .padding(.leading, 60)
            .padding(.trailing, 60)
        }
    }
}
