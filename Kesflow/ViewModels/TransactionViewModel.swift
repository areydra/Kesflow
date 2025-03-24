//
//  TransactionViewModel.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/17/25.
//

import Foundation
import CoreData

@Observable class TransactionViewModel {
    var transactions: [TransactionEntity] = []
    var context: NSManagedObjectContext
    
    init (context: NSManagedObjectContext) {
        self.context = context
        getTransactions()
    }
    
    func getTransactions() {
        let request: NSFetchRequest = NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
        
        do {
            transactions = try context.fetch(request).sorted{($0.createdAt ?? Date()) > ($1.createdAt ?? Date())}
        } catch let error as NSError {
            print("Error while loading transaction entity: \(error)")
        }
    }
    
    func saveTransaction(_ transaction: TransactionModel) {
        let newTransaction = TransactionEntity(context: self.context)
        newTransaction.name = transaction.name
        newTransaction.quantity = transaction.quantity
        newTransaction.salePrice = transaction.salePrice
        newTransaction.totalSalePrice = transaction.totalSalePrice
        newTransaction.createdAt = transaction.date
        newTransaction.costPrice = transaction.costPrice
        newTransaction.note = transaction.note
        newTransaction.unit = transaction.unit
        newTransaction.profit = transaction.profit
        newTransaction.productStock = transaction.productStock

        transaction.productStock.stock -= transaction.quantity
        
        saveDatabase()
    }
    
    func deleteTransaction(_ transaction: TransactionEntity) {
        transaction.productStock?.stock += transaction.quantity
        context.delete(transaction)
        saveDatabase()
    }
    
    func saveDatabase() {
        transactions.removeAll()
        do {
            try context.save()
            getTransactions()
        } catch let error as NSError {
            print("Error while saving database: \(error)")
        }
    }
}
