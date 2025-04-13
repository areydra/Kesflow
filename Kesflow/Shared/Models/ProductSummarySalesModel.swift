//
//  ProductSummaryModel.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 4/3/25.
//

import Foundation

struct ProductSummarySalesModel {
    var totalProductsSold: Int16
    var totalSalesRevenue: Int32
    var totalProfit: Int32
    var date: Date
    
    init(totalProductsSold: Int16, totalSalesRevenue: Int32, totalProfit: Int32, date: Date) {
        self.totalProductsSold = totalProductsSold
        self.totalSalesRevenue = totalSalesRevenue
        self.totalProfit = totalProfit
        self.date = date
    }
    
    init(from model: TransactionModel) {
        self.totalProductsSold = model.quantity
        self.totalSalesRevenue = model.totalSalePrice
        self.totalProfit = model.profit
        self.date = model.date
    }
}
