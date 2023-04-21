//
//  MainPage.swift
//  pennyearned
//
//  Created by Vaibhav Venkat on 4/15/23.
//

import SwiftUI
struct ExpenseListView: View {
    let expenses: [Expense]
    let deleteExpense: (Expense) -> Void
    let updateExpense: (Expense, String?, Int?) -> Void
    @State private var isShowingAlert = false
    @State private var isShowingEditSheet = false
    @State private var expenseToDelete: Expense?
    @State private var expenseToUpdate: Expense?
    var body: some View {
        List(expenses, id: \.id) { expense in
            Button(action: {
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(expense.name).font(.headline)
                        Text("$\(expense.spent)").font(.subheadline)
                        Text("\(daysSinceLastUpdate(dateUpdated: expense.date_updated))").font(.caption)
                    }.foregroundColor(.primary)
                    Spacer()
                    Button(action: {
                        expenseToUpdate = expense
                        isShowingAlert = true
                    }) {
                        Image(systemName: "square.and.pencil")
                    }
                    .foregroundColor(.primary)
                    Button(action: {
                        expenseToDelete = expense
                        isShowingAlert = true
                    }) {
                        Image(systemName: "trash")
                    }
                    .foregroundColor(.primary)
                }

            }
            .listRowBackground(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.primary, lineWidth: 3)
                    .padding(.bottom, 20)
                    .padding(.leading, 6)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            )
            .padding(.bottom, 20)
        }
        .listStyle(.insetGrouped)
        .alert(isPresented: $isShowingAlert) {
            if let expense = expenseToDelete {
                return Alert(title: Text("Delete Expense"), message: Text("Are you sure you want to delete this expense?"), primaryButton: .destructive(Text("Delete")) {
                    deleteExpense(expense)
                    expenseToDelete = nil
                }, secondaryButton: .cancel() {
                    expenseToDelete = nil
                    isShowingAlert = false
                })
            } else if let _ = expenseToUpdate{
                return Alert(title: Text("Update Expense"), message: Text("Do you want to update this expense?"), primaryButton: .default(Text("Update")) {
                    isShowingEditSheet = true
                }, secondaryButton: .cancel() {
                    expenseToUpdate = nil
                    isShowingAlert = false
                })
            } else {
                return Alert(title: Text("error"))
            }
        }
        .sheet(isPresented: $isShowingEditSheet) {
            if let _ = expenseToUpdate {
                ExpenseEditView(expense: expenseToUpdate!, isShowingSheet: $isShowingEditSheet, newName: "", newSpent: "", updateExpense: updateExpense)
            }
        }
    }
    
}
private func daysSinceLastUpdate(dateUpdated: String) -> String {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds, .withTimeZone]
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    if let date = formatter.date(from: dateUpdated) {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: date, to: now)
        
        if let days = components.day, days > 0 {
            return "\(days) \(days == 1 ? "day": "days") ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours) \(hours == 1 ? "hour": "hours") ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes) \(minutes == 1 ? "minute" : "minutes") ago"
        } else if let seconds = components.second, seconds > 0 {
            return "\(seconds) \(seconds == 1 ? "second" : "seconds") ago"
        } else {
            return "now"
        }
    } else {
        return dateUpdated
    }
}

struct ExpenseEditView: View {
    let expense: Expense
    @Binding var isShowingSheet: Bool
    @State var newName: String
    @State var newSpent: String
    let updateExpense: (Expense, String?, Int?) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Edit Expense")
                    .font(.title)
                    .padding()
                FormInputField(text: $newName, placeholder: expense.name, secure: false)
                    .padding(.top, 30)
                FormInputField(text: $newSpent, placeholder: "$\(expense.spent)", secure: false)
                    .keyboardType(.numberPad)
                Spacer()
                Button(action: {
                    updateExpense(expense, newName.isEmpty ? nil : newName, newSpent.isEmpty ? nil : Int(newSpent))
                    isShowingSheet = false
                }) {
                    Text("Save")
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
            .padding(.trailing, 30)
            .padding(.leading, 30)
            .buttonStyle(RoundedButtonStyle())
        }
    }
}
struct ExpenseFormView: View {
    @Binding var newExpenseName: String
    @Binding var newExpenseSpent: Int
    @FocusState var isFocused : Bool
    let addUserExpense: () -> Void
    let getAllExpenses: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                TextField("Name", text: $newExpenseName)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.primary, lineWidth: 3)
                            .padding(.leading, 6)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    )
                    .foregroundColor(.primary)
                    .focused($isFocused)
                TextField("Spent", value: $newExpenseSpent, formatter: NumberFormatter())
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.primary, lineWidth: 3)
                            .padding(.leading, 6)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    )
                    .foregroundColor(.primary)
                    .keyboardType(.numberPad)
                    .focused($isFocused)
            }
            HStack {
                Button(action: {
                    isFocused = false
                    addUserExpense()
                }) {
                    Text("Add")
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                .buttonStyle(RoundedButtonStyle())
                Button(action: {
                    isFocused = false
                    getAllExpenses()
                }) {
                    Text("Refresh")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(RoundedButtonStyle())
            }
        }
        .padding()
    }
}

struct MainPage: View {
    @State private var user: User
    @State private var expenses: [Expense] = []
    @State private var newExpenseName: String = ""
    @State private var newExpenseSpent: Int = 0
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        VStack {
            Text("Expenses").font(.title)
            ExpenseListView(expenses: expenses, deleteExpense: deleteExpense, updateExpense: updateExpense)
            ExpenseFormView(newExpenseName: $newExpenseName, newExpenseSpent: $newExpenseSpent) {
                AddExpense(ownerId: user.id, name: newExpenseName, spent: newExpenseSpent) { res in
                    switch res {
                    case .ok:
                        GetAll(userId: user.id) { result in
                            switch result {
                            case .statusBad(let code):
                                if code == 404 {
                                    self.expenses = []
                                }
                            case .good(let expenses):
                                self.expenses = expenses
                                newExpenseName = ""
                                newExpenseSpent = 0
                            case .bad(let msg):
                                print("Error: \(msg)")
                            }
                        }
                    case .bad:
                        print("Error: couldn't insert expense")
                    }
                }
            } getAllExpenses: {
                GetAll(userId: user.id) { result in
                    switch result {
                    case .statusBad(let code):
                        if code == 404 {
                            self.expenses = []
                        }
                    case .good(let expenses):
                        self.expenses = expenses
                        newExpenseName = ""
                        newExpenseSpent = 0
                    case .bad(let msg):
                        print("Error: \(msg)")
                    }
                }
            }
        }
        .onAppear {
            GetAll(userId: user.id) { result in
                switch result {
                case .statusBad(let code):
                    if code == 404 {
                        self.expenses = []
                    }
                case .good(let expenses):
                    self.expenses = expenses
                case .bad(let msg):
                    print("Error: \(msg)")
                }
            }
        }
    }
    
    func deleteExpense(_ expense: Expense) {
        DeleteExpense(expenseId: expense.id) { res in
            switch res {
            case .ok:
                GetAll(userId: user.id) { result in
                    switch result {
                    case .statusBad(let code):
                        if code == 404 {
                            self.expenses = []
                        }
                    case .good(let expenses):
                        self.expenses = expenses
                    case .bad(let msg):
                        print(msg)
                    }
                }
            case .bad(let msg):
                print(msg)
            }
        }
    }
    
    func updateExpense(_ expense: Expense, name: String?, spent: Int?) {
        UpdateExpense(expenseId: expense.id, name: name, spent: spent) { res in
            switch res {
            case .ok:
                GetAll(userId: user.id) { result in
                    switch result {
                    case .statusBad(let code):
                        if code == 404 {
                            self.expenses = []
                        }
                    case .good(let expenses):
                        self.expenses = expenses
                    case .bad(let msg):
                        print("Error: \(msg)")
                    }
                }
            case .bad:
                print("Error: couldn't update expense")
            }
        }
    }
}
