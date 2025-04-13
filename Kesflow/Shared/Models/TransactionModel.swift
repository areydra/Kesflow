//
//  TransactionModel.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/17/25.
//

import Foundation
import CoreData

struct TransactionModel {
    let name: String
    let quantity: Int16
    let salePrice: Int32
    let totalSalePrice: Int32
    let date: Date
    let costPrice: Int32
    let note: String
    let unit: String
    let profit: Int32
    let productStock: ProductStockEntity
    let product: ProductEntity?
    
    init(name: String, quantity: Int16, salePrice: Int32, totalSalePrice: Int32, date: Date, costPrice: Int32, note: String, unit: String, profit: Int32, productStock: ProductStockEntity, product: ProductEntity? = nil) {
        self.name = name
        self.quantity = quantity
        self.salePrice = salePrice
        self.totalSalePrice = totalSalePrice
        self.date = date
        self.costPrice = costPrice
        self.note = note
        self.unit = unit
        self.profit = profit
        self.productStock = productStock
        self.product = product
    }
    
    init(from entity: TransactionEntity) {
        self.name = entity.name ?? ""
        self.quantity = entity.quantity
        self.salePrice = entity.salePrice
        self.totalSalePrice = entity.totalSalePrice
        self.date = entity.createdAt ?? Date()
        self.costPrice = entity.costPrice
        self.note = entity.note ?? ""
        self.unit = entity.unit ?? ""
        self.profit = entity.profit
        self.productStock = entity.productStock ?? ProductStockEntity(context: KesflowManager.instance.context)
        self.product = entity.product
    }
}
