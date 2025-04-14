//
//  RootView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 2/28/25.
//

import SwiftUI

struct RootView: View {
    private let productService: ProductService

    @State private var navigationViewModel: NavigationViewModel = .init()
    @State private var tabProductViewModel: TabProductViewModel
    @State private var tabTransactionViewModel: TabTransactionViewModel = .init()
    @StateObject private var productSummaryService: ProductSummaryService = .init()
    
    init() {
        self.productService = .init()
        _tabProductViewModel = .init(wrappedValue: .init(productService: self.productService))
    }
    

    var body: some View {
        NavigationStack(path: $navigationViewModel.path) {
            DashboardView(
                productSummaryService: productSummaryService,
                tabProductViewModel: tabProductViewModel,
                tabTransactionViewModel: tabTransactionViewModel
            )
            .navigationDestination(for: NavigationKey.self) { key in
                switch key {
                    case .AddProduct:
                        AddProductView(productSummaryService: productSummaryService)
                        .environment(tabProductViewModel)
                    case .EditProduct:
                        EditProductView(productSummaryService: productSummaryService)
                        .environment(tabProductViewModel)
                    case .AddTransaction:
                        AddTransactionView(
                            productService: productService as ProductServiceProviding,
                            productSummaryService: productSummaryService
                        )
                        .environment(tabTransactionViewModel)
                    case .EditTransaction:
                        EditTransactionView(
                            productService: productService as ProductServiceProviding,
                            productSummaryService: productSummaryService
                        )
                        .environment(tabTransactionViewModel)
                }
            }
        }
        .environment(navigationViewModel)
    }
}

#Preview {
    RootView()
}
