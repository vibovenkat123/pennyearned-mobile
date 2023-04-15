//  SignUpView.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 3/12/23.
//

import SwiftUI
struct FirstSignUpPage: View {
    @State private var email: String = ""
    @State private var showAlert: Bool = false
    @State private var emailBad: Bool
    init(emailBad: Bool) {
        self.emailBad = emailBad
    }
    var body: some View {
        NavigationStack {
            VStack{
                FormInputField(text: $email, placeholder: "Email", secure: false)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                GoToButton(destination:
                            AnyView(
                                SecondSignUpPage(email: email)
                                    .onAppear(perform:{
                                        validateEmail(email: email)
                                    })
                            ),
                           text: "Verify", imageName: "arrow.forward")
            }
            .padding(.leading, 60)
            .padding(.trailing, 60)
            VStack {
                NavigationLink(destination:
                                SignInPage()
                    .navigationBarBackButtonHidden(true)
                ) {
                    Text("Already have an account? Sign In")
                }
            }
        }
        .alert("Email not valid",
               isPresented: $emailBad) {
        }
    }
    
}

