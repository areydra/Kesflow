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
    var body: some View {
        NavigationStack {
            DashboardView()
            .navigationDestination(for: ViewKeys.self) { key in
                switch key {
                    case .AddProduct:
                        AddProductView()
                    case .EditProduct:
                        EditProductView()
                    case .AddTransaction:
                        Text("Add Transaction")
                    case .EditTransaction:
                        Text("Edit Transaction")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
