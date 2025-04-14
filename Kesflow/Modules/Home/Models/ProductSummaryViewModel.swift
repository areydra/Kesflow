//
//  ProductSummarySalesModel.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 4/3/25.
//

import Foundation
import CoreData
import Combine

class ProductSummaryViewModel: ObservableObject {
    @Published var selectedDate: Date? = nil
    @Published var isShowCalendarModal: Bool = false

    @Published var productSummaryStock: ProductSummaryStockModel? = nil
    @Published var productSummarySales: ProductSummarySalesModel? = nil
    
    var cancellables = Set<AnyCancellable>()
    let productSummaryService: ProductSummaryServiceProviding
    
    init(productSummaryService: ProductSummaryServiceProviding) {
        self.productSummaryService = productSummaryService

        productSummaryService.productSummarySalesPublisher
                    .receive(on: RunLoop.main)
                    .assign(to: &$productSummarySales)
        productSummaryService.productSummaryStockPublisher
                    .receive(on: RunLoop.main)
                    .assign(to: &$productSummaryStock)

        subscriptionSelectedDate()
    }
    
    func showCalendarModal() {
        isShowCalendarModal.toggle()
    }

    func subscriptionSelectedDate() {
        $selectedDate
            .compactMap { $0 }
            .sink { date in
                self.productSummaryService.getProductSummarySalesByDate(date: date)
            }
            .store(in: &cancellables)
    }
}
