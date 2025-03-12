//
//  ProductModel.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/2/25.
//

import Foundation

struct ProductModel: Identifiable, Encodable, Decodable {
    var id: String
    var name: String
    var recommendedPrice: Int
    var listProductStock: [ProductStockModel]
    
    init(id: String = UUID().uuidString, name: String, recommendedPrice: Int, listProductStock: [ProductStockModel]) {
        self.id = id
        self.name = name
        self.recommendedPrice = recommendedPrice
        self.listProductStock = listProductStock
    }
    
    func updateProductStock(index: Int, newProductStock: ProductStockModel) -> ProductModel {
        var newListProductStock = self.listProductStock
        newListProductStock[index] = newListProductStock[index].update(stock: newProductStock.stock, unit: newProductStock.unit, costPrice: newProductStock.costPrice)
        
        return ProductModel(id: self.id, name: self.name, recommendedPrice: self.recommendedPrice, listProductStock: newListProductStock)
    }
}
