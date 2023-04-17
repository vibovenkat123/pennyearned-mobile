//
//  expenses.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 4/15/23.
//

import Foundation
enum ExpensesRes {
    case good([Expense])
    case bad(String)
    case statusBad(Int)
}

enum InsertExpenseResult {
    case ok
    case bad
}

enum DeleteExpenseResult {
    case ok
    case bad(String)
}

enum ExpenseUpdateResult {
    case ok
    case bad
}


struct ExpensesResult: Codable {
    var expenses: [Expense]
}
func GetAll(userId: String, completion: @escaping (ExpensesRes) -> Void) {
    let url = URL(string: "\(Globals.expensesServer)/v1/api/expense/user/\(userId)/expenses")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil, let response = response as? HTTPURLResponse else {
            completion(.bad("Err is not nil \(String(describing: error))"))
            return
        }
        switch response.statusCode {
        case 200:
            break
        default:
            completion(.statusBad(response.statusCode))
        }
        if let expenses = try? JSONDecoder().decode(ExpensesResult.self, from: data) {
            // expenses successfully retrieved
            completion(.good(expenses.expenses))
            return
        } else {
            print(try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
            completion(.bad("Couldn't decode"))
        }
    }

    task.resume()
}

func AddExpense(ownerId: String, name: String, spent: Int, completion: @escaping (InsertExpenseResult) -> Void) {
    let url = URL(string: "\(Globals.expensesServer)/v1/api/expense")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let requestBody: [String: Any] = [
        "owner_id": ownerId,
        "name": name,
        "spent": spent
    ]
    
    guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
            print("here 77")
        completion(.bad)
        return
    }
    
    request.httpBody = httpBody

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            print("here 86")
            completion(.bad)
            return
        }

        guard let res = response as? HTTPURLResponse, res.statusCode == 201 else  {
            let res = response as? HTTPURLResponse
            print(res!.statusCode)
            completion(.bad)
            return
        }
        completion(.ok)
    }

    task.resume()
}

func DeleteExpense(expenseId: String, completion: @escaping (DeleteExpenseResult) -> Void) {
    guard let url = URL(string: "\(Globals.expensesServer)/v1/api/expense/\(expenseId)") else {
        completion(.bad("Invalid URL"))
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.bad("Error: \(error.localizedDescription)"))
            return
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.bad("Error: unexpected response"))
            return
        }
        if httpResponse.statusCode == 204 {
            completion(.ok)
        } else {
            completion(.bad("Error: unexpected status code \(httpResponse.statusCode)"))
        }
    }.resume()
}

func UpdateExpense(expenseId: String, name: String?, spent: Int?, completion: @escaping (ExpenseUpdateResult) -> Void) {
    guard let url = URL(string: "\(Globals.expensesServer)/v1/api/expense/\(expenseId)") else {
        completion(.bad)
        return
    }
    var request = URLRequest(url: url)
    let requestBody: [String: Any] = [
        "name": name,
        "spent": spent
    ]
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "PATCH"
    guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
        completion(.bad)
        return
    }
    request.httpBody = httpBody
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let _ = error {
            completion(.bad)
            return
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.bad)
            return
        }
        if httpResponse.statusCode == 200 {
            completion(.ok)
        } else {
            completion(.bad)
        }
    }.resume()
}
