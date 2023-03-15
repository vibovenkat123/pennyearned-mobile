//  SignUpView.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 3/12/23.
//

import SwiftUI
struct FirstSignUpPage: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    var body: some View {
        NavigationStack {
            VStack{
                FormInputField(text: $email, placeholder: "Email")
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                GoToButton(destination:
                            AnyView(
                                SecondSignUpPage(email: email, password: password)
                                    .onAppear(perform:{
                                        validateEmail(email: email)
                                    })
                                   ),
                           text: "Verify", imageName: "arrow.forward")
            }
            .padding(.leading, 60)
            .padding(.trailing, 60)
            VStack {
                NavigationLink(destination: SignInPage()) {
                    Text("Already have an account? Sign In")
                }
            }
        }
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        FirstSignUpPage()
    }
}
