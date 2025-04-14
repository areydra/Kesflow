//
//  TabProductViewModel.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/12/25.
//

import Foundation
import CoreData

// Move crud operation into service and add getProducts, and getSpecificProduct into protocol

@MainActor
@Observable class TabProductViewModel {
    let productService: ProductService
    
    var products: [ProductEntity] = []
    var selectedProduct: ProductEntity?
    
    init(productService: ProductService) {
        self.productService = productService

        if let products = productService.get() {
            self.products = products
        }
    }

    func add(name: String, recommendedPrice: Int32, listProductStock: [ProductStockEntity]) async {
        guard let product = await productService.add(name: name, recommendedPrice: recommendedPrice, listProductStock: listProductStock) else {
            return
        }

        products.append(product)
    }

    func edit(newName: String, newRecommendedPrice: Int32, listProductStock: [ProductStockEntity]) async {
        guard let selectedProduct = self.selectedProduct,
              let editedProduct = await productService.edit(selectedProductEntity: selectedProduct, newName: newName, newRecommendedPrice: newRecommendedPrice, listProductStock: listProductStock),
              let index = products.firstIndex(where: { $0 === editedProduct })
               else { return }
        
        products[index] = editedProduct
    }
    
    func delete(product: ProductEntity) async {
        do {
            try await productService.delete(product: product)
            guard let index = products.firstIndex(where: { $0 === product }) else { return }
            products.remove(at: index)
        } catch let error {
            print("error: \(error)")
        }
    }
    
    func setSelectedProduct(product: ProductEntity) {
        self.selectedProduct = product
    }
    
    func removeSelectedProduct() {
        self.selectedProduct = nil
    }
}
