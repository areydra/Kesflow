//
//  DashboardView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 2/28/25.
//

import SwiftUI

struct DashboardView: View {
    @State private var selectedTab: Int = 0
    @State var tabProductViewModel: TabProductViewModel
    @State var tabTransactionViewModel: TabTransactionViewModel
    @StateObject private var productSummaryViewModel: ProductSummaryViewModel

    let productSummaryService: ProductSummaryServiceProviding
    
    init(
        productSummaryService: ProductSummaryServiceProviding,
        tabProductViewModel: TabProductViewModel,
        tabTransactionViewModel: TabTransactionViewModel
    ) {
        self.productSummaryService = productSummaryService
        self.tabProductViewModel = tabProductViewModel
        self.tabTransactionViewModel = tabTransactionViewModel
        
        _productSummaryViewModel = StateObject(wrappedValue: ProductSummaryViewModel(productSummaryService: productSummaryService))
    }

    var body: some View {
        TabView(selection: $selectedTab, content: {
            TabHomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
                .environmentObject(productSummaryViewModel)

            TabProductView(productSummaryService: productSummaryService)
                .tabItem {
                    Image(systemName: "tray.fill")
                    Text("Products")
                }
                .tag(1)
                .environment(tabProductViewModel)
            
            TabTransactionView(productSummaryService: productSummaryService)
                .tabItem {
                    Image(systemName: "receipt.fill")
                    Text("Transactions")
                }
                .tag(2)
                .environment(tabTransactionViewModel)
        })
    }
}

#Preview {
    DashboardView(
        productSummaryService: ProductSummaryService(),
        tabProductViewModel: TabProductViewModel(productService: ProductService()),
        tabTransactionViewModel: TabTransactionViewModel()
    )
}
