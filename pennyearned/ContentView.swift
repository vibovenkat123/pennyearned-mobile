//
//  ContentView.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 3/9/23.
//

import SwiftUI

struct ContentView: View {
    @State private var onWelcome: Bool = false
    @State private var showAlert = false
    @State private var signedIn: Bool = false
    @State private var onSignUp: Bool = false
    @State private var user: User = Globals.user
    var body: some View {
        VStack {
            if signedIn {
                MainPage(user: user)
            } else if onWelcome {
                // the very first page you see
                BeginningPage(onWelcome: $onWelcome, onSignup: $onSignUp)
            } else if onSignUp {
                FirstSignUpPage()
            }
        }
        .onAppear(perform: {
            if let password = Globals.keychain["password"],
               let username = Globals.keychain["username"] {
                SignIn(username: username, password: password) { res in
                    switch res {
                    case .notFound:
                        onWelcome = true
                        signedIn = false
                    case .good(let user):
                        Globals.user = user
                        self.user = Globals.user
                        signedIn = true
                    }
                }
            } else {
                onWelcome = true
                signedIn = false
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
