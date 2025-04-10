//
//  ProductSummaryStockViewModel.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 4/9/25.
//

import Foundation
import CoreData
import Combine

class ProductSummaryStockService: ObservableObject {
    @Published var productSummaryStock: ProductSummaryStockModel? = nil
    
    var context: NSManagedObjectContext = DatabaseViewModel.instance.context
    var cancellables = Set<AnyCancellable>()
    
    func get() -> ProductSummaryStockModel {
        var totalProductStock: Int16 = 0
        var totalMoneyInStock: Int32 = 0
        let request: NSFetchRequest = NSFetchRequest<ProductStockEntity>(entityName: "ProductStockEntity")

        do {
            let listProductStock: [ProductStockEntity] = try self.context.fetch(request)

            for productStock in listProductStock {
                totalProductStock += productStock.stock
                totalMoneyInStock += (productStock.costPrice * Int32(productStock.stock))
            }
        } catch let error as NSError {
            print("Error while get product stock: \(error)")
        }

        return ProductSummaryStockModel(totalProductStock: totalProductStock, totalMoneyInStock: totalMoneyInStock)
    }

    func add(
        productSummaryStock: ProductSummaryStockModel,
        transaction: TransactionModel
    ) -> ProductSummaryStockModel {
        return ProductSummaryStockModel(
            totalProductStock: (
                productSummaryStock.totalProductStock - transaction.quantity
            ),
            totalMoneyInStock: (
                productSummaryStock.totalMoneyInStock - (transaction.totalSalePrice - transaction.profit)
            )
        )
    }
    
    func edit(
        productSummaryStock: ProductSummaryStockModel,
        oldTransaction: TransactionModel,
        newTransaction: TransactionModel
    ) -> ProductSummaryStockModel {
        let oldProductSummaryStock: ProductSummaryStockModel = ProductSummaryStockModel(
            totalProductStock: oldTransaction.quantity,
            totalMoneyInStock: oldTransaction.totalSalePrice - oldTransaction.profit
        )
        let newProductSummaryStock: ProductSummaryStockModel = ProductSummaryStockModel(
            totalProductStock: newTransaction.quantity,
            totalMoneyInStock: newTransaction.totalSalePrice - newTransaction.profit
        )

        return ProductSummaryStockModel(
            totalProductStock: (
                productSummaryStock.totalProductStock - (newProductSummaryStock.totalProductStock - oldProductSummaryStock.totalProductStock)
            ),
            totalMoneyInStock: (
                productSummaryStock.totalMoneyInStock - (newProductSummaryStock.totalMoneyInStock - oldProductSummaryStock.totalMoneyInStock)
            )
        )
    }
    
    func delete(
        productSummaryStock: ProductSummaryStockModel,
        transaction: TransactionModel
    ) -> ProductSummaryStockModel {
        return ProductSummaryStockModel(
            totalProductStock: productSummaryStock.totalProductStock + transaction.quantity,
            totalMoneyInStock: productSummaryStock.totalMoneyInStock + (transaction.totalSalePrice - transaction.profit)
        )
    }
}
