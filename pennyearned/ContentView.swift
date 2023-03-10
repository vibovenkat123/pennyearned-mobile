//
//  ContentView.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 3/9/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("PennyEarned")
                .font(.title)
                .padding(.bottom, 40)
            SignUpButton()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
