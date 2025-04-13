//
//  ProductSummarySalesService.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 4/9/25.
//

import Foundation
import CoreData
import Combine

class ProductSummarySalesService {
    var context: NSManagedObjectContext = KesflowManager.instance.context
    var cancellables = Set<AnyCancellable>()
    
    func getLatest() -> ProductSummarySalesEntity? {
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
        var productSummarySales: ProductSummarySalesEntity? = nil
        let request: NSFetchRequest<ProductSummarySalesEntity> = NSFetchRequest(entityName: "ProductSummarySalesEntity")
        let bounds = dayBounds(for: date)

        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", bounds.start as NSDate, bounds.end as NSDate)
        request.fetchLimit = 1

        do {
            productSummarySales = try context.fetch(request).first
        } catch {
            print("Error while fetching specific product summary: \(error)")
            return nil
        }
        
        return productSummarySales
    }
    
    private func dayBounds(for date: Date) -> (start: Date, end: Date) {
        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? start
        return (start, end)
    }
    
    func add(transaction: TransactionModel) -> ProductSummarySalesEntity? {
        handleProductSummarySales(isActionDelete: false, productSummaryModel: ProductSummarySalesModel(from: transaction))
        saveToDatabase()
        return getLatest()
    }

    
    func edit(oldTransaction: TransactionModel, newTransaction: TransactionModel) -> ProductSummarySalesEntity? {
        if newTransaction.date != oldTransaction.date {
            // delete old summary based on date
            handleProductSummarySales(isActionDelete: true, productSummaryModel: ProductSummarySalesModel(from: oldTransaction))

            // add new summary in based on new date
            handleProductSummarySales(isActionDelete: false, productSummaryModel: ProductSummarySalesModel(from: newTransaction))
        } else {
            handleProductSummarySales(
                isActionDelete: false,
                productSummaryModel:
                    ProductSummarySalesModel(
                        totalProductsSold: newTransaction.quantity - oldTransaction.quantity,
                        totalSalesRevenue: newTransaction.totalSalePrice - oldTransaction.totalSalePrice,
                        totalProfit: newTransaction.profit - oldTransaction.profit,
                        date: newTransaction.date
                    )
            )
        }
        
        saveToDatabase()
        return getLatest()
    }
    
    func delete(transaction: TransactionModel) -> ProductSummarySalesEntity? {
        handleProductSummarySales(isActionDelete: true, productSummaryModel: ProductSummarySalesModel(from: transaction))
        saveToDatabase()
        return getLatest()
    }
    
    func handleProductSummarySales(
        isActionDelete: Bool,
        productSummaryModel: ProductSummarySalesModel
    ) {
        let productSummarySalesEntity: ProductSummarySalesEntity = self.getSpecificByDate(date: productSummaryModel.date) ?? ProductSummarySalesEntity(context: context)

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
