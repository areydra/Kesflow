//
//  ListProductViewModel.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/12/25.
//

import Foundation
import CoreData

@Observable class ListProductViewModel {
    let context: NSManagedObjectContext
    
    var products: [ProductEntity] = []
    var selectedProduct: ProductEntity?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.getProducts()
    }
    
    func getProducts() {
        let request: NSFetchRequest = NSFetchRequest<ProductEntity>(entityName: "ProductEntity")

        do {
            products = try self.context.fetch(request)
        } catch let error as NSError {
            print("Error while get products: \(error)")
        }
    }
    
    func getSpecificProduct(name: String?) -> ProductEntity? {
        guard let name = name else { return nil }
        
        let request: NSFetchRequest<ProductEntity> = NSFetchRequest(entityName: "ProductEntity")
        request.predicate = NSPredicate(format: "name CONTAINS[c] %@", name)

        do {
            return try self.context.fetch(request).first
        } catch let error as NSError {
            print("Error while getting specific product: \(error)")
            return nil
        }
    }

    func addProduct(name: String, recommendedPrice: Int32, listProductStock: [ProductStockEntity]) {
        let newProduct = ProductEntity(context: context)
        newProduct.name = name
        newProduct.recommendedPrice = recommendedPrice
        newProduct.listProductStock = NSSet(array: listProductStock)
        
        saveDataIntoDatabase()
    }

    func editProduct(newName: String, newRecommendedPrice: Int32, listProductStock: [ProductStockEntity]) {
        guard let selectedProduct = self.selectedProduct else { return }
        
        selectedProduct.name = newName
        selectedProduct.recommendedPrice = newRecommendedPrice
        selectedProduct.listProductStock = NSSet(array: listProductStock)
        
        saveDataIntoDatabase()
    }
    
    func productStockEntity(costPrice: Int32, stock: Int16, unit: String) -> ProductStockEntity {
        let productStock = ProductStockEntity(context: context)
        productStock.costPrice = costPrice
        productStock.stock = stock
        productStock.unit = unit
        
        return productStock
    }
    
    func deleteProduct(product: ProductEntity) {
        self.context.delete(product)
        saveDataIntoDatabase()
    }
    
    func setSelectedProduct(product: ProductEntity) {
        self.selectedProduct = product
    }
    
    func removeSelectedProduct() {
        self.selectedProduct = nil
    }
    
    func saveDataIntoDatabase() {
        do {
            self.products.removeAll()
            try self.context.save()
            self.getProducts()
        } catch let error as NSError {
            print("Error while saving data into database: \(error)")
        }
    }
}
