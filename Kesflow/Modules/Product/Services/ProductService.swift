//
//  ProductService.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 4/14/25.
//

import CoreData

@MainActor
class ProductService: @preconcurrency ProductServiceProviding {
    let context: NSManagedObjectContext = KesflowManager.instance.context
    
    func get() -> [ProductEntity]? {
        let request: NSFetchRequest = NSFetchRequest<ProductEntity>(entityName: "ProductEntity")

        do {
            return try self.context.fetch(request)
        } catch let error as NSError {
            print("Error while get products: \(error)")
            return nil
        }
    }
    
    func getSpecificByName(name: String?) -> ProductEntity? {
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

    func add(name: String, recommendedPrice: Int32, listProductStock: [ProductStockEntity]) async -> ProductEntity? {
        let newProduct = ProductEntity(context: context)
        newProduct.name = name
        newProduct.recommendedPrice = recommendedPrice
        newProduct.listProductStock = NSSet(array: listProductStock)
        
        do {
            try await saveDataIntoDatabase()
            
            return newProduct
        } catch let error {
            print("Error while adding a new product: \(error)")
            return nil
        }
    }

    func edit(
        selectedProductEntity: ProductEntity,
        newName: String,
        newRecommendedPrice: Int32,
        listProductStock: [ProductStockEntity]
    ) async -> ProductEntity? {
        selectedProductEntity.name = newName
        selectedProductEntity.recommendedPrice = newRecommendedPrice
        selectedProductEntity.listProductStock = NSSet(array: listProductStock)
        
        do {
            try await saveDataIntoDatabase()
            return selectedProductEntity
        } catch let error {
            print("Error while editing a product: \(error)")
            return nil
        }
    }
    
    func productStockEntity(costPrice: Int32, stock: Int16, unit: String) -> ProductStockEntity {
        let productStock = ProductStockEntity(context: context)
        productStock.costPrice = costPrice
        productStock.stock = stock
        productStock.unit = unit
        
        return productStock
    }
    
    func delete(product: ProductEntity) async throws {
        self.context.delete(product)
        
        do {
            try await saveDataIntoDatabase()
        } catch let error {
            print("Error while deleting a product: \(error)")
            throw error
        }
    }
    
    func saveDataIntoDatabase() async throws {
        do {
            try self.context.save()
        } catch let error as NSError {
            throw error
        }
    }
}
