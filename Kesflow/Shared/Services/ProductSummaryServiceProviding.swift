//
//  ProductSummaryProviding.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 4/13/25.
//

import Foundation

protocol ProductSummaryServiceProviding {
    var productSummaryStockPublisher: Published<ProductSummaryStockModel?>.Publisher { get }
    var productSummarySalesPublisher: Published<ProductSummarySalesModel?>.Publisher { get }

    
    func getProductSummarySalesByDate(date: Date)
    func refreshProductSummaryStock()
    func add(transaction: TransactionModel)
    func edit(oldTransaction: TransactionModel, newTransaction: TransactionModel)
    func delete(transaction: TransactionModel)
}
