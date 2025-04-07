//
//  ContentView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 2/28/25.
//

import SwiftUI

enum ViewKeys: String, CaseIterable, Hashable {
    case AddProduct
    case EditProduct
    case AddTransaction
    case EditTransaction
}

struct ContentView: View {
    private var databaseViewModel = DatabaseViewModel()
    @State private var listProductViewModel: ListProductViewModel
    @State private var transactionViewModel: TransactionViewModel
    @State private var navigationViewModel = NavigationViewModel()
    @StateObject private var productSummaryViewModel: ProductSummaryViewModel

    init() {
        let dbContext = databaseViewModel.context
        _listProductViewModel = .init(initialValue: ListProductViewModel(context: dbContext))
        _transactionViewModel = .init(initialValue: TransactionViewModel(context: dbContext))
        _productSummaryViewModel = .init(wrappedValue: ProductSummaryViewModel(context: dbContext))
    }

    var body: some View {
        NavigationStack(path: $navigationViewModel.path) {
            DashboardView()
            .navigationDestination(for: ViewKeys.self) { key in
                switch key {
                    case .AddProduct:
                        AddProductView()
                    case .EditProduct:
                        EditProductView()
                    case .AddTransaction:
                        AddTransactionView()
                    case .EditTransaction:
                        EditTransactionView()
                }
            }
        }
        .environment(listProductViewModel)
        .environment(navigationViewModel)
        .environment(transactionViewModel)
        .environmentObject(productSummaryViewModel)
    }
}

#Preview {
    ContentView()
}
