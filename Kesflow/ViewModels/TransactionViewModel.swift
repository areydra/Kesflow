//
//  TransactionViewModel.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/17/25.
//

import Foundation
import CoreData

@MainActor
@Observable class TransactionViewModel {
    static let instance = TransactionViewModel()
    
    var transactions: [TransactionEntity] = []
    var context: NSManagedObjectContext = DatabaseViewModel.instance.context
    var selectedTransaction: TransactionEntity? = nil
    
    init () {
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
    
    func saveTransaction(_ transaction: TransactionModel) async {
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
        await saveDatabase()
    }

    func editTransaction(transaction: TransactionEntity, newTransaction: TransactionModel) async {
        if (
            ((transaction.quantity != newTransaction.quantity) || (transaction.productStock != newTransaction.productStock))
            &&
            transaction.productStock != nil
        ) {
            if transaction.productStock != newTransaction.productStock {
                transaction.productStock?.stock += transaction.quantity

                transaction.productStock = newTransaction.productStock
                transaction.productStock?.stock -= newTransaction.quantity
            } else {
                transaction.productStock?.stock += (transaction.quantity - newTransaction.quantity)
            }
        }

        
        transaction.name = newTransaction.name
        transaction.quantity = newTransaction.quantity
        transaction.salePrice = newTransaction.salePrice
        transaction.totalSalePrice = newTransaction.totalSalePrice
        transaction.createdAt = newTransaction.date
        transaction.costPrice = newTransaction.costPrice
        transaction.note = newTransaction.note
        transaction.unit = newTransaction.unit
        transaction.profit = newTransaction.profit
        transaction.product = newTransaction.product

        await saveDatabase()
    }

    func setSelectedTransaction(_ transaction: TransactionEntity) {
        self.selectedTransaction = transaction
    }
    
    func deleteTransaction(_ transaction: TransactionEntity) async {
        transaction.productStock?.stock += transaction.quantity
        context.delete(transaction)

        await saveDatabase()
    }
    
    func saveDatabase() async {
        transactions.removeAll()
        do {
            try context.save()
            getTransactions()
        } catch let error as NSError {
            print("Error while saving database: \(error)")
        }
    }
}
