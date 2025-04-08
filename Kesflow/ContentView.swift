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
    @State private var navigationViewModel = NavigationViewModel()

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
        .environment(navigationViewModel)
    }
}

#Preview {
    ContentView()
}
