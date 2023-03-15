//
//  globals.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 3/9/23.
//

import Foundation
import SwiftUI
struct Globals {
    static let btnColor:Color = Color(red: 0.06274509803921569, green: 0.5215686274509804, blue: 0.8549019607843137)
}
struct User:Codable {
    let email: String
    let password: String
    let username: String
    let name: String
}
