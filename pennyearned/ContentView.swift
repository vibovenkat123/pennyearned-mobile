//
//  ContentView.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 3/9/23.
//

import SwiftUI

struct ContentView: View {
    @State private var onWelcome: Bool = true
    var body: some View {
        if onWelcome {
            // the very first page you see
            BeginningPage(onWelcome: $onWelcome)
        } else {
            FirstSignUpPage()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
