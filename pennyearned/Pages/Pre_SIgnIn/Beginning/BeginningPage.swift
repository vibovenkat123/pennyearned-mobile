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
            FirstSignUpPage()
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
                    FeatureCell(image: "dollarsign.square", title: "Organize your expenses", subtitle: "See whats costing you the most, and work towards cutting it down", color: .primary)
                    
                    FeatureCell(image: "cloud", title: "All synced", subtitle: "Pennyearned allows you to kep your expenses synced across other devices", color: .primary)
                    
                    FeatureCell(image: "lock", title: "No credit card required", subtitle: "Pennyearned keeps the sensitive data out of this, it doesn't use a credit card to track income or expenses", color: .primary)
                }
                .padding(.leading)
                Spacer()
                Spacer()
                VStack {
                    Button(action: {
                        onWelcome = false
                        onSignup = true
                    }) {
                        HStack{
                            Spacer()
                            Text("Get Started")
                                .fontWeight(.semibold)
                                .padding()
                                .cornerRadius(10)
                            Spacer()
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    .cornerRadius(10)
                }
                .padding()
                .buttonStyle(RoundedButtonStyle(borderWidth: 3, cornerRadius: 10, borderColor: .primary))
                Spacer()
            }
            .interactiveDismissDisabled()
        })
    }
}

