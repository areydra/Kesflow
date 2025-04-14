//
//  ProductSummarySalesModel.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 4/3/25.
//

import Foundation

class ProductSummaryService: ObservableObject, ProductSummaryServiceProviding {
    @Published var productSummaryStock: ProductSummaryStockModel? = nil
    @Published var productSummarySales: ProductSummarySalesModel? = nil
    
    var productSummaryStockPublisher: Published<ProductSummaryStockModel?>.Publisher { $productSummaryStock }
    var productSummarySalesPublisher: Published<ProductSummarySalesModel?>.Publisher { $productSummarySales }
    
    let productSummaryStockService: ProductSummaryStockService = .init()
    let productSummarySalesService: ProductSummarySalesService = .init()
    
    init() {
        self.productSummarySales = self.productSummarySalesService.getLatest()
        self.productSummaryStock = self.productSummaryStockService.get()
    }

    func getProductSummarySalesByDate(date: Date) {
        if let productSummarySalesEntityByDate = self.productSummarySalesService.getSpecificByDate(date: date) {
            self.productSummarySales = ProductSummarySalesModel(from: productSummarySalesEntityByDate)
        }
    }
    
    func refreshProductSummaryStock() {
        DispatchQueue.main.async {
            self.productSummaryStock = self.productSummaryStockService.get()
        }
    }
    
    func add(transaction: TransactionModel) {
        self.productSummarySales = productSummarySalesService.add(transaction: transaction)
        
        if let productSummaryStock = self.productSummaryStock {
            self.productSummaryStock = productSummaryStockService.add(
                productSummaryStock: productSummaryStock,
                transaction: transaction
            )
        }
    }
    
    func edit(oldTransaction: TransactionModel, newTransaction: TransactionModel) {
        let isTransactionChanged: Bool = (oldTransaction.quantity != newTransaction.quantity) || (oldTransaction.productStock != newTransaction.productStock) || (oldTransaction.date != newTransaction.date)
        
        guard let productSummaryStock = self.productSummaryStock,
              isTransactionChanged else { return }

        self.productSummarySales = productSummarySalesService.edit(
            oldTransaction: oldTransaction,
            newTransaction: newTransaction
        )

        self.productSummaryStock = productSummaryStockService.edit(
            productSummaryStock: productSummaryStock,
            oldTransaction: oldTransaction,
            newTransaction: newTransaction
        )
    }
    
    func delete(transaction: TransactionModel) {
        self.productSummarySales = productSummarySalesService.delete(transaction: transaction)
        
        if let productSummaryStock = self.productSummaryStock {
            self.productSummaryStock = productSummaryStockService.delete(
                productSummaryStock: productSummaryStock,
                transaction: transaction
            )
        }
    }
}
