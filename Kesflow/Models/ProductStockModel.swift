//
//  ProductModel.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/2/25.
//

import Foundation

struct ProductStockModel: Identifiable, Encodable, Decodable {
    var id: String
    var stock: Int
    var unit: String
    var costPrice: Int
    
    init(id: String = UUID().uuidString, stock: Int, unit: String, costPrice: Int) {
        self.id = id
        self.stock = stock
        self.unit = unit
        self.costPrice = costPrice
    }
    
    func update(stock: Int?, unit: String?, costPrice: Int?) -> ProductStockModel {
        ProductStockModel(
            id: self.id,
            stock: stock ?? self.stock,
            unit: unit ?? self.unit,
            costPrice: costPrice ?? self.costPrice
        )
    }
}
