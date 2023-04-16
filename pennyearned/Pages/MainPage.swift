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
    let updateExpense: (Expense, String?, Int?) -> Void // Added parameter for updating an expense
    @State private var isShowingConfirmationAlert = false
    @State private var isShowingEditSheet = false
    @State private var expenseToDelete: Expense?
    @State private var expenseToUpdate: Expense?
    var body: some View {
        List(expenses, id: \.id) { expense in
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(expense.name).font(.headline)
                    Text("$\(expense.spent)").font(.subheadline)
                }
                Spacer()
                Image(systemName: "dollarsign.circle")
                    .foregroundColor(.blue)
                Button(action: {
                    expenseToUpdate = expense
                    isShowingConfirmationAlert = true
                }) {
                    Image(systemName: "square.and.pencil")
                }
                .foregroundColor(.green)
                Button(action: {
                    expenseToDelete = expense
                    isShowingConfirmationAlert = true
                }) {
                    Image(systemName: "trash")
                }
                .foregroundColor(.red)
            }
        }
        .listStyle(.insetGrouped)
        .alert(isPresented: $isShowingConfirmationAlert) {
            if let expense = expenseToUpdate {
                return Alert(title: Text("Update Expense"), message: Text("Update the name and/or spent amount"), primaryButton: .default(Text("Update")) {
                    isShowingEditSheet = true
                }, secondaryButton: .cancel())
            } else if let expense = expenseToDelete {
                return Alert(title: Text("Delete Expense"), message: Text("Are you sure you want to delete this expense?"), primaryButton: .destructive(Text("Delete")) {
                    deleteExpense(expense)
                }, secondaryButton: .cancel())
            } else {
                return Alert(title: Text("Error"), message: Text("Something went wrong"), dismissButton: .default(Text("OK")))
            }
        }
        .sheet(isPresented: $isShowingEditSheet) {
            ExpenseEditView(expense: expenseToUpdate!, isShowingSheet: $isShowingEditSheet, newName: "", newSpent: "", updateExpense: updateExpense)
        }
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
                TextField(expense.name, text: $newName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("$\(expense.spent)", text: $newSpent)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                Spacer()
                Button(action: {
                    updateExpense(expense, newName.isEmpty ? nil : newName, newSpent.isEmpty ? nil : Int(newSpent))
                    isShowingSheet = false
                }) {
                    Text("Save")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Globals.btnColor)
                        )
                }
            }
            .padding()
            .navigationTitle("Edit Expense")
        }
    }
}
struct ExpenseFormView: View {
    @Binding var newExpenseName: String
    @Binding var newExpenseSpent: Int
    let addUserExpense: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                TextField("Name", text: $newExpenseName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Spent", value: $newExpenseSpent, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            }
            .padding(.bottom, 10)
            
            Button(action: addUserExpense) {
                Text("Add")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Globals.btnColor)
                    .cornerRadius(10)
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
