//
//  MainPage.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 4/15/23.
//

import SwiftUI

struct MainPage: View {
    @State private var user: User
    init(user: User) {
        self.user = user
    }
    var body: some View {
        Text("Hello, \(user.username)!")
        Text("email: \(user.email)")
        Text("pwd: \(user.password)")
        Text("id: \(user.id)")
    }
}
