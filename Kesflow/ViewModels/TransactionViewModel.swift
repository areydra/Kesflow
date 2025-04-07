//
//  TransactionViewModel.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/17/25.
//

import Foundation
import CoreData

// TODO: Integrate productSummaryViewModel when user do Create/Update/Delete Transaction

@Observable class TransactionViewModel {
    var transactions: [TransactionEntity] = []
    var context: NSManagedObjectContext
    var selectedTransaction: TransactionEntity? = nil
    var productSummaryViewModel: ProductSummaryViewModel
    
    init (context: NSManagedObjectContext) {
        self.context = context
        self.productSummaryViewModel = ProductSummaryViewModel(context: context)
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

        saveDatabase {
            self.productSummaryViewModel.saveProductSummarySales(.create, newProductSummarySalesModel: ProductSummarySalesModel(
                totalProductsSold: transaction.quantity,
                totalSalesRevenue: transaction.totalSalePrice,
                totalProfit: transaction.profit,
                date: transaction.date
            ))
            self.productSummaryViewModel.saveProductSummaryStock(.create, newProductSummaryStockModel: ProductSummaryStockModel(
                totalProductStock: transaction.quantity,
                totalMoneyInStock: transaction.totalSalePrice - transaction.profit
            ))
        }
    }

    func editTransaction(transaction: TransactionEntity, newTransaction: TransactionModel) {
        var oldProductSummarySales, newProductSummarySales: ProductSummarySalesModel?
        var oldProductSummaryStock, newProductSummaryStock: ProductSummaryStockModel?
        let isTransactionQuantityChanged: Bool = ((transaction.quantity != newTransaction.quantity) || (transaction.productStock != newTransaction.productStock)) && transaction.productStock != nil
        
        if isTransactionQuantityChanged || (transaction.createdAt != newTransaction.date) {
            oldProductSummarySales = ProductSummarySalesModel(
                totalProductsSold: transaction.quantity,
                totalSalesRevenue: transaction.totalSalePrice,
                totalProfit: transaction.profit,
                date: transaction.createdAt ?? Date()
            )
            
            newProductSummarySales = ProductSummarySalesModel(
                totalProductsSold: newTransaction.quantity,
                totalSalesRevenue: newTransaction.totalSalePrice,
                totalProfit: newTransaction.profit,
                date: newTransaction.date
            )
            
            oldProductSummaryStock = ProductSummaryStockModel(
                totalProductStock: transaction.quantity,
                totalMoneyInStock: transaction.totalSalePrice - transaction.profit
            )
            
            newProductSummaryStock = ProductSummaryStockModel(
                totalProductStock: newTransaction.quantity,
                totalMoneyInStock: newTransaction.totalSalePrice - newTransaction.profit
            )
        }
        
        if isTransactionQuantityChanged {
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

        saveDatabase() {
            guard let newProductSummarySales = newProductSummarySales,
                  let oldProductSummarySales = oldProductSummarySales,
                  let newProductSummaryStock = newProductSummaryStock,
                  let oldProductSummaryStock = oldProductSummaryStock else { return }

            self.productSummaryViewModel.saveProductSummarySales(.update, newProductSummarySalesModel: newProductSummarySales, oldProductSummaryStockModel: oldProductSummarySales)
            self.productSummaryViewModel.saveProductSummaryStock(.update, newProductSummaryStockModel: newProductSummaryStock, oldProductSummaryStockModel: oldProductSummaryStock)
        }
    }

    func setSelectedTransaction(_ transaction: TransactionEntity) {
        self.selectedTransaction = transaction
    }
    
    func deleteTransaction(_ transaction: TransactionEntity) {
        let productSummarySales = ProductSummarySalesModel(
            totalProductsSold: transaction.quantity,
            totalSalesRevenue: transaction.totalSalePrice,
            totalProfit: transaction.profit,
            date: transaction.createdAt ?? Date()
        )
        let productSummaryStock = ProductSummaryStockModel(
            totalProductStock: transaction.quantity,
            totalMoneyInStock: transaction.totalSalePrice - transaction.profit
        )
        transaction.productStock?.stock += transaction.quantity
        context.delete(transaction)

        saveDatabase {
            self.productSummaryViewModel.saveProductSummarySales(.delete, newProductSummarySalesModel: productSummarySales)
            self.productSummaryViewModel.saveProductSummaryStock(.delete, newProductSummaryStockModel: productSummaryStock)
        }
    }
    
    func saveDatabase(action: @escaping () -> Void = {}) {
        transactions.removeAll()
        do {
            try context.save()
            getTransactions()
            action()
        } catch let error as NSError {
            print("Error while saving database: \(error)")
        }
    }
}
