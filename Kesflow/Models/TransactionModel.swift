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
}
