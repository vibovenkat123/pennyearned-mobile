//
//  globals.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 3/9/23.
//

import Foundation
import SwiftUI
import KeychainAccess
struct Globals {
    @Environment(\.colorScheme) var colorScheme
//    static let userServer: String = "https://aq9q963cc2.execute-api.us-east-1.amazonaws.com/dev"
//    static let expensesServer: String = "https://aq9q963cc2.execute-api.us-east-1.amazonaws.com/dev"
    static let userServer: String = "http://192.168.1.181:3002"
    static let expensesServer: String = "http://192.168.1.181:3001"
    static let keychain = Keychain(service: "com.vaibhav.pennyearned.keychain")
                            .label("pennyearned credentials")
                            .synchronizable(true)
    static var user = User(id: "", email: "", password: "", username: "", date_created: "", date_updated: "", budget: 0)
}
struct User:Codable {
    var id: String
    var email: String
    var password: String
    var username: String
    var date_created: String
    var date_updated: String
    var budget: Int
}

struct Expense: Codable{
    var id: String
    var owner_id: String
    var name: String
    var date_created: String
    var date_updated: String
    var spent: Int
}
