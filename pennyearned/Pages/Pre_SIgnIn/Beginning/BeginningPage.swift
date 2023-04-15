//
//  BeginningPage.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 3/12/23.
//

import SwiftUI

struct BeginningPage: View {
    @Binding var onWelcome: Bool
    @Binding var onSignup: Bool
    var body: some View {
        VStack {
            FirstSignUpPage(emailBad: false)
        }.sheet(isPresented: $onWelcome, content: {
            VStack {
                Spacer()
                Text("Welcome to PennyEarned")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 48)
                Spacer()
                VStack(spacing: 24) {
                    FeatureCell(image: "dollarsign.square", title: "Organize your expenses", subtitle: "See whats costing you the most, and work towards cutting it down", color: .green)
                    
                    FeatureCell(image: "gift", title: "Manage your budgets", subtitle: "Set your income and what your budgets are so you can start saving towards the next big thing", color: .red)
                    
                    FeatureCell(image: "lock", title: "No credit card required", subtitle: "Pennyearned keeps the sensitive data out of this, it doesn't use a credit card to track income or expenses", color: .blue)
                }
                .padding(.leading)
                Spacer()
                Spacer()
                VStack {
                    Button(action: {
                        onWelcome = false
                        onSignup = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Get Started")
                            Spacer()
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Globals.btnColor)
                    .cornerRadius(10)
                }
                .padding()
                Spacer()
            }
            .interactiveDismissDisabled()
        })
    }
}

