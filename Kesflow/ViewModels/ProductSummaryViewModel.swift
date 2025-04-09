//
//  ProductSummarySalesModel.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 4/3/25.
//

import Foundation
import CoreData
import Combine

class ProductSummaryViewModel: ObservableObject {
    @Published var selectedDate: Date? = nil
    @Published var isShowCalendarModal: Bool = false

    @Published var productSummaryStock: ProductSummaryStockModel? = nil
    @Published var productSummarySales: ProductSummarySalesEntity? = nil
    
    let productSummaryStockService: ProductSummaryStockService = .init()
    let productSummarySalesService: ProductSummarySalesService = .init()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        self.productSummarySales = self.productSummarySalesService.get()
        self.productSummaryStock = self.productSummaryStockService.get()
        subscriptionSelectedDate()
    }
    
    func showCalendarModal() {
        isShowCalendarModal.toggle()
    }

    func subscriptionSelectedDate() {
        $selectedDate
            .compactMap { $0 }
            .sink { date in
                if let productSummarySalesByDate = self.productSummarySalesService.getSpecificByDate(date: date) {
                    self.productSummarySales = productSummarySalesByDate
                }
            }
            .store(in: &cancellables)
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
    
    func edit(oldTransaction: TransactionEntity, newTransaction: TransactionModel) {
        let isTransactionQuantityChanged: Bool = ((oldTransaction.quantity != newTransaction.quantity) || (oldTransaction.productStock != newTransaction.productStock)) && oldTransaction.productStock != nil

        guard let productSummaryStock = self.productSummaryStock,
              isTransactionQuantityChanged || (oldTransaction.createdAt != newTransaction.date) else { return }

        self.productSummarySales = productSummarySalesService.edit(
            currentProductSummarySales: self.productSummarySales,
            oldTransaction: oldTransaction,
            newTransaction: newTransaction
        )

        self.productSummaryStock = productSummaryStockService.edit(
            productSummaryStock: productSummaryStock,
            oldTransaction: oldTransaction,
            newTransaction: newTransaction
        )
    }
    
    func delete(transaction: TransactionEntity) {
        self.productSummarySales = productSummarySalesService.delete(
            currentProductSummarySales: self.productSummarySales,
            transaction: transaction
        )
        
        if let productSummaryStock = self.productSummaryStock {
            self.productSummaryStock = productSummaryStockService.delete(
                productSummaryStock: productSummaryStock,
                transaction: transaction
            )
        }
    }
}
