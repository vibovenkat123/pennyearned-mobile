//
//  ValidateFields.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 3/12/23.
//

import Foundation
enum SignUpResFirst {
    case BadEmail
    case Good
}
func validatePwd(password: String) -> Bool {
    return password.count >= 8 && password.count <= 20
}
func validateEmail(email: String, completion: @escaping (SignUpResFirst) -> Void) {
    guard let url = URL(string: "\(Globals.userServer)/v1/api/user") else {
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body: [String: AnyHashable] = [
        "email": email
    ]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    let task = URLSession.shared.dataTask(with: request, completionHandler: { data, res, error in
        guard
            let res = res as? HTTPURLResponse,
            error == nil
        else {
            return
        }
        guard 202 ~= res.statusCode else {
            if res.statusCode == 400 {
                completion(.BadEmail)
            }
            return
        }
        completion(.Good)
    })
    task.resume()
}
