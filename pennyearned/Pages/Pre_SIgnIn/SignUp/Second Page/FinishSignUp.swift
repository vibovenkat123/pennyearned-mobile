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

func validateEmail(email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

enum Response {
    case invalidCode
    case misc
    case good
    case usernameAlrFound
    case msg(String)
}
func finishSignup(credentials: Credentials, code: String, completion: @escaping (Response) -> Void) {
    let account = credentials.username
    let password = credentials.password
    guard let url = URL(string: "\(Globals.server)/v1/api/user/verify/\(code)") else {
        completion(.misc)
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body: [String: AnyHashable] = [
        "username": account,
        "password": password,
    ]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    var err = Response.good
    let task = URLSession.shared.dataTask(with: request, completionHandler: { data, res, error in
        guard
            let res = res as? HTTPURLResponse,
            error == nil
        else {
            completion(.misc)
            return
        }
        guard res.statusCode == 201 else {
            switch res.statusCode {
            case 404:
                err = Response.invalidCode
            case 409:
                err = Response.usernameAlrFound
            default:
                err = Response.msg("Unkown \(res.statusCode)")
            }
            completion(err)
            return
        }
        Globals.keychain["password"] = password
        Globals.keychain["username"] = account
        completion(.good)
    })
    task.resume()
}
