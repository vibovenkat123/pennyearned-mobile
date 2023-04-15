//
//  signin_start.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 4/15/23.
//

import Foundation
enum SignUpRes {
    case notFound
    case good(User)
}
struct AccessRes: Codable {
    var user: AccessToken
}
struct AccessToken: Codable {
    var access_token: String
}
struct UserRes: Codable {
    var user: User
}
func SignIn(username: String, password: String, completion: @escaping (SignUpRes) -> Void) {
    guard var url = URL(string: "\(Globals.server)/v1/api/user/session") else {
        completion(.notFound)
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let body: [String: AnyHashable] = [
        "username": username,
        "password": password,
    ]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    let task = URLSession.shared.dataTask(with: request, completionHandler: { data, res, error in
        guard
            let res = res as? HTTPURLResponse,
            let data = data,
            error == nil
        else {
            completion(.notFound)
            return
        }
        guard 200 ~= res.statusCode else {
            completion(.notFound)
            return
        }
        do {
            let response = try JSONDecoder().decode(AccessRes.self, from: data)
            url = URL(string: "\(Globals.server)/v1/api/user/\(response.user.access_token)")!
            var newReq = URLRequest(url: url)
            newReq.httpMethod = "GET"
            newReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let newTask = URLSession.shared.dataTask(with: newReq, completionHandler: { data, res, error in
                guard
                    let res = res as? HTTPURLResponse,
                    let data = data,
                    error == nil
                else {
                    completion(.notFound)
                    return
                }
                guard 200 ~= res.statusCode else {
                    completion(.notFound)
                    return
                }
                do {
                    let userRes: UserRes = try JSONDecoder().decode(UserRes.self, from: data)
                    var user: User = userRes.user
                    user.password = password
                    completion(.good(user))
                } catch {
                    completion(.notFound)
                }
            })
            newTask.resume()
        } catch {
            completion(.notFound)
        }
    })
    task.resume()
}
