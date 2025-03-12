//
//  ProductViewModel.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/2/25.
//

import Foundation

@Observable class ProductsViewModel {
    private let productsLocalKey:String = "products_local_key"

    var products: [ProductModel] = [] {
        didSet {
            saveProductToLocalStorage()
        }
    }
    
    init() {
        getProducts()
    }
    
    func getProducts() {
        guard
            let productLocalStorage = UserDefaults.standard.data(forKey: productsLocalKey),
            let decodeProductLocal = try? JSONDecoder().decode([ProductModel].self, from: productLocalStorage)
        else {
            return
        }
        
        self.products = decodeProductLocal
    }
    
    func getSpecificProduct(id: String) -> ProductModel? {
        return products.first(where: { $0.id == id })
    }
    
    func saveProductToLocalStorage() {
        if let encodeData = try? JSONEncoder().encode(products) {
            UserDefaults.standard.set(encodeData, forKey: productsLocalKey)
        }
    }
    
    func addProduct(product: ProductModel) {
        products.append(product)
    }
    
    func editProduct(product: ProductModel) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index] = product
        }
    }
    
    func deleteProduct(product: ProductModel) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products.remove(at: index)
        }
    }

    func editProductStock(product: ProductModel, indexStock: Int, newProductStock: ProductStockModel) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index] = product.updateProductStock(index: indexStock, newProductStock: newProductStock)
        }
    }
}
