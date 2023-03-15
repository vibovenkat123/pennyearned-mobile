//
//  ValidateFields.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 3/12/23.
//

import Foundation

func validatePwd(password: String) -> Bool {
    return password.count >= 8 && password.count <= 20
}

func validateEmail(email: String) {
    print(email)
    guard let url = URL(string: "https://tu7m2gsigi.execute-api.us-east-1.amazonaws.com/dev/api/user") else {
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body: [String: AnyHashable] = [
        "email": email
    ]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    print(request)
    let task = URLSession.shared.dataTask(with: request, completionHandler: { data, res, error in
        guard
            let data = data,
            let res = res as? HTTPURLResponse,
            error == nil
        else {
            print("error", error ?? URLError(.badServerResponse))
            return
        }
        guard 202 ~= res.statusCode else {
            print(data)
            print("The status code returned was not successful. Status Code: \(res.statusCode)")
            return
        }
        print("Sucessfully called the api with status code: \(res.statusCode)")
    })
    task.resume()
}
