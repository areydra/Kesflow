//
//  ProductSummarySalesService.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 4/9/25.
//

import Foundation
import CoreData
import Combine

class ProductSummarySalesService: ObservableObject {
    var context: NSManagedObjectContext = DatabaseViewModel.instance.context
    var cancellables = Set<AnyCancellable>()
    
    func get() -> ProductSummarySalesEntity? {
        let request: NSFetchRequest = NSFetchRequest<ProductSummarySalesEntity>(entityName: "ProductSummarySalesEntity")

        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch let error as NSError {
            print("Error while fetching product summary \(error)")
            return nil
        }
    }
    
    func getSpecificByDate(date: Date) -> ProductSummarySalesEntity? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? Date()
        let request: NSFetchRequest<ProductSummarySalesEntity> = NSFetchRequest(entityName: "ProductSummarySalesEntity")

        var productSummarySales: ProductSummarySalesEntity? = nil

        do {
            request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
            request.fetchLimit = 1
            productSummarySales = try context.fetch(request).first
        } catch {
            print("Error while fetching specific product summary: \(error)")
            return nil
        }
        
        return productSummarySales
    }

    func getEntity(
        currentProductSummarySales: ProductSummarySalesEntity? = nil,
        productSummarySales: ProductSummarySalesModel
    ) -> ProductSummarySalesEntity {
        if let currentProductSummarySales = currentProductSummarySales,
           let productSummaryEntityDate = currentProductSummarySales.date,
           let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: productSummaryEntityDate),
           productSummarySales.date >= productSummaryEntityDate && productSummarySales.date < tomorrow
        {
            return currentProductSummarySales
        } else if let productSummarySalesEntityByDate = self.getSpecificByDate(date: productSummarySales.date) {
            return productSummarySalesEntityByDate
        } else {
            return ProductSummarySalesEntity(context: context)
        }
    }
    
    func add(
        currentProductSummarySales: ProductSummarySalesEntity? = nil,
        transaction: TransactionModel
    ) -> ProductSummarySalesEntity? {
        handleProductSummarySales(
            isActionDelete: false,
            currentProductSummarySales: currentProductSummarySales,
            productSummaryModel:
                ProductSummarySalesModel(
                    totalProductsSold: transaction.quantity,
                    totalSalesRevenue: transaction.totalSalePrice,
                    totalProfit: transaction.profit,
                    date: transaction.date
                )
        )
        
        saveToDatabase()
        return get()
    }

    
    func edit(
        currentProductSummarySales: ProductSummarySalesEntity? = nil,
        oldTransaction: TransactionEntity,
        newTransaction: TransactionModel
    ) -> ProductSummarySalesEntity? {
        let oldProductSummarySalesModel = ProductSummarySalesModel(
            totalProductsSold: oldTransaction.quantity,
            totalSalesRevenue: oldTransaction.totalSalePrice,
            totalProfit: oldTransaction.profit,
            date: oldTransaction.createdAt ?? Date()
        )

        let newProductSummarySalesModel = ProductSummarySalesModel(
            totalProductsSold: newTransaction.quantity,
            totalSalesRevenue: newTransaction.totalSalePrice,
            totalProfit: newTransaction.profit,
            date: newTransaction.date
        )
        
        if newProductSummarySalesModel.date != oldProductSummarySalesModel.date {
            // delete old summary based on date
            handleProductSummarySales(
                isActionDelete: true,
                currentProductSummarySales: currentProductSummarySales,
                productSummaryModel:
                    ProductSummarySalesModel(
                        totalProductsSold: oldProductSummarySalesModel.totalProductsSold,
                        totalSalesRevenue: oldProductSummarySalesModel.totalSalesRevenue,
                        totalProfit: oldProductSummarySalesModel.totalProfit,
                        date: oldProductSummarySalesModel.date
                    )
            )

            // add new summary in based on new date
            handleProductSummarySales(
                isActionDelete: false,
                currentProductSummarySales: currentProductSummarySales,
                productSummaryModel:
                    ProductSummarySalesModel(
                        totalProductsSold: newProductSummarySalesModel.totalProductsSold,
                        totalSalesRevenue: newProductSummarySalesModel.totalSalesRevenue,
                        totalProfit: newProductSummarySalesModel.totalProfit,
                        date: newProductSummarySalesModel.date
                    )
            )
        } else {
            handleProductSummarySales(
                isActionDelete: false,
                currentProductSummarySales: currentProductSummarySales,
                productSummaryModel:
                    ProductSummarySalesModel(
                        totalProductsSold: newProductSummarySalesModel.totalProductsSold - oldProductSummarySalesModel.totalProductsSold,
                        totalSalesRevenue: newProductSummarySalesModel.totalSalesRevenue - oldProductSummarySalesModel.totalSalesRevenue,
                        totalProfit: newProductSummarySalesModel.totalProfit - oldProductSummarySalesModel.totalProfit,
                        date: newProductSummarySalesModel.date
                    )
            )
        }
        
        saveToDatabase()
        return get()
    }
    
    func delete(
        currentProductSummarySales: ProductSummarySalesEntity? = nil,
        transaction: TransactionEntity
    ) -> ProductSummarySalesEntity? {
        let productSummarySalesModel = ProductSummarySalesModel(
            totalProductsSold: transaction.quantity,
            totalSalesRevenue: transaction.totalSalePrice,
            totalProfit: transaction.profit,
            date: transaction.createdAt ?? Date()
        )
        
        handleProductSummarySales(
            isActionDelete: true,
            currentProductSummarySales: currentProductSummarySales,
            productSummaryModel:
                ProductSummarySalesModel(
                    totalProductsSold: productSummarySalesModel.totalProductsSold,
                    totalSalesRevenue: productSummarySalesModel.totalSalesRevenue,
                    totalProfit: productSummarySalesModel.totalProfit,
                    date: productSummarySalesModel.date
                )
            )
        
        saveToDatabase()
        return get()
    }
    
    func handleProductSummarySales(
        isActionDelete: Bool,
        currentProductSummarySales: ProductSummarySalesEntity? = nil,
        productSummaryModel: ProductSummarySalesModel
    ) {
        let productSummarySalesEntity: ProductSummarySalesEntity = getEntity(
            currentProductSummarySales: currentProductSummarySales,
            productSummarySales: productSummaryModel
        )

        productSummarySalesEntity.totalProductsSold = isActionDelete ? (productSummarySalesEntity.totalProductsSold - productSummaryModel.totalProductsSold) : (productSummarySalesEntity.totalProductsSold + productSummaryModel.totalProductsSold)
        productSummarySalesEntity.totalSalesRevenue = isActionDelete ? (productSummarySalesEntity.totalSalesRevenue - productSummaryModel.totalSalesRevenue) : (productSummarySalesEntity.totalSalesRevenue + productSummaryModel.totalSalesRevenue)
        productSummarySalesEntity.totalProfit = isActionDelete ? (productSummarySalesEntity.totalProfit - productSummaryModel.totalProfit) : (productSummarySalesEntity.totalProfit + productSummaryModel.totalProfit)
        
        if !isActionDelete {
            productSummarySalesEntity.date = productSummaryModel.date
        }
    }

    private func saveToDatabase() {
        do {
            try context.save()
        } catch let error {
            print("Error while saving product summary into database \(error)")
        }
    }
}
