//
//  ValidateSignUp.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 4/12/23.
//

import Foundation

func validateUsername(username: String) -> Bool {
    return username.count > 2 && username.count < 12
}

func validatePass(password: String) -> Bool {
    return password.count >= 8 && password.count <= 20
}

func validateCode(code: String) -> Bool {
    return code.count == 6
}
