//
//  ProductSummarySalesModel.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 4/3/25.
//

import Foundation
import CoreData
import Combine

enum ProductSummaryAction {
    case create
    case update
    case delete
}

class ProductSummaryViewModel: ObservableObject {
    static let instance = ProductSummaryViewModel()
    
    @Published var productSummarySales: ProductSummarySalesEntity? = nil
    @Published var selectedDate: Date? = nil
    @Published var isShowCalendarModal: Bool = false
    @Published var productSummaryStock: ProductSummaryStockModel? = nil
    
    var context: NSManagedObjectContext = DatabaseViewModel.instance.context
    var cancellables = Set<AnyCancellable>()
    
    private init() {
        getProductSummary()
        getTotalProductSummaryStock()
        subscriptionSelectedDate()
    }
    
    func showCalendarModal() {
        isShowCalendarModal.toggle()
    }

    func subscriptionSelectedDate() {
        $selectedDate
            .compactMap { $0 }
            .sink { date in
                guard let productSummarySalesByDate = self.getSpecificProductSummarySalesByDate(date: date) else {
                    return
                }

                self.productSummarySales = productSummarySalesByDate
            }
            .store(in: &cancellables)
    }

    func getProductSummary() {
        let request: NSFetchRequest = NSFetchRequest<ProductSummarySalesEntity>(entityName: "ProductSummarySalesEntity")

        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.fetchLimit = 1
        
        do {
            productSummarySales = try context.fetch(request).first
        } catch let error as NSError {
            print("Error while fetching product summary \(error)")
        }
    }
    
    func getTotalProductSummaryStock() {
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

        productSummaryStock = ProductSummaryStockModel(totalProductStock: totalProductStock, totalMoneyInStock: totalMoneyInStock)
    }

    
    func getSpecificProductSummarySalesByDate(date: Date) -> ProductSummarySalesEntity? {
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

    func getProductSummaryEntity(newProductSummarySalesModel: ProductSummarySalesModel) -> ProductSummarySalesEntity {
        var productSummarySalesEntity: ProductSummarySalesEntity

        if let productSummarySales = self.productSummarySales,
           let productSummaryEntityDate = productSummarySales.date,
           let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: productSummaryEntityDate),
           newProductSummarySalesModel.date >= productSummaryEntityDate && newProductSummarySalesModel.date < tomorrow {
            productSummarySalesEntity = productSummarySales
        } else {
            productSummarySalesEntity = self.getSpecificProductSummarySalesByDate(date: newProductSummarySalesModel.date) ?? ProductSummarySalesEntity(context: context)
        }
        
        return productSummarySalesEntity
    }

    func saveProductSummarySales(_ action: ProductSummaryAction, newProductSummarySalesModel: ProductSummarySalesModel, oldProductSummaryStockModel: ProductSummarySalesModel? = nil) {
        let isActionDelete = action == .delete

        let totalProductsSold = (newProductSummarySalesModel.totalProductsSold - (oldProductSummaryStockModel?.totalProductsSold ?? 0))
        let totalSalesRevenue = (newProductSummarySalesModel.totalSalesRevenue - (oldProductSummaryStockModel?.totalSalesRevenue ?? 0))
        let totalProfit = (newProductSummarySalesModel.totalProfit - (oldProductSummaryStockModel?.totalProfit ?? 0))
        
        if let oldProductSummaryStockModel = oldProductSummaryStockModel,
           newProductSummarySalesModel.date != oldProductSummaryStockModel.date {
            // delete old summary based on date
            handleProductSummarySales(
                isActionDelete: true,
                productSummaryModel:
                    ProductSummarySalesModel(
                        totalProductsSold: oldProductSummaryStockModel.totalProductsSold,
                        totalSalesRevenue: oldProductSummaryStockModel.totalSalesRevenue,
                        totalProfit: oldProductSummaryStockModel.totalProfit,
                        date: oldProductSummaryStockModel.date
                    )
            )

            // add new summary in based on new date
            handleProductSummarySales(
                isActionDelete: false,
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
                isActionDelete: isActionDelete,
                productSummaryModel:
                    ProductSummarySalesModel(
                        totalProductsSold: totalProductsSold,
                        totalSalesRevenue: totalSalesRevenue,
                        totalProfit: totalProfit,
                        date: newProductSummarySalesModel.date
                    )
            )
        }
    }
    
    func saveProductSummaryStock(_ action: ProductSummaryAction, newProductSummaryStockModel: ProductSummaryStockModel, oldProductSummaryStockModel: ProductSummaryStockModel? = nil) {
        updateProductSummaryStock(
            action,
            newProductSummaryStockModel: newProductSummaryStockModel,
            oldProductSummaryStockModel: oldProductSummaryStockModel
        )
    }
    
    func handleProductSummarySales(isActionDelete: Bool, productSummaryModel: ProductSummarySalesModel) {
        let productSummarySalesEntity: ProductSummarySalesEntity = getProductSummaryEntity(newProductSummarySalesModel: productSummaryModel)

        productSummarySalesEntity.totalProductsSold = isActionDelete ? (productSummarySalesEntity.totalProductsSold - productSummaryModel.totalProductsSold) : (productSummarySalesEntity.totalProductsSold + productSummaryModel.totalProductsSold)
        productSummarySalesEntity.totalSalesRevenue = isActionDelete ? (productSummarySalesEntity.totalSalesRevenue - productSummaryModel.totalSalesRevenue) : (productSummarySalesEntity.totalSalesRevenue + productSummaryModel.totalSalesRevenue)
        productSummarySalesEntity.totalProfit = isActionDelete ? (productSummarySalesEntity.totalProfit - productSummaryModel.totalProfit) : (productSummarySalesEntity.totalProfit + productSummaryModel.totalProfit)
        
        if !isActionDelete {
            productSummarySalesEntity.date = productSummaryModel.date
        }
        
        saveToDatabase()
    }

    func updateProductSummaryStock(_ action: ProductSummaryAction, newProductSummaryStockModel: ProductSummaryStockModel, oldProductSummaryStockModel: ProductSummaryStockModel? = nil) {
        guard var productSummaryStock = productSummaryStock else { return }
        
        let isActionDelete = action == .delete
        let totalProductStock = (newProductSummaryStockModel.totalProductStock - (oldProductSummaryStockModel?.totalProductStock ?? 0))
        let totalMoneyInStock = (newProductSummaryStockModel.totalMoneyInStock - (oldProductSummaryStockModel?.totalMoneyInStock ?? 0))

        productSummaryStock = ProductSummaryStockModel(
            totalProductStock: isActionDelete ? (productSummaryStock.totalProductStock + totalProductStock) : (productSummaryStock.totalProductStock - totalProductStock),
            totalMoneyInStock: isActionDelete ? (productSummaryStock.totalMoneyInStock + totalMoneyInStock) : (productSummaryStock.totalMoneyInStock - totalMoneyInStock)
        )
    }

    func saveToDatabase() {
        do {
            getProductSummary()
            try context.save()
        } catch let error {
            print("Error while saving product summary into database \(error)")
        }
    }
}
