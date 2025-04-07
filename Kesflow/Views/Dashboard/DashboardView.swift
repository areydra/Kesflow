//
//  DashboardView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 2/28/25.
//

import SwiftUI

struct DashboardView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab, content: {
            TabHomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            ProductsView()
                .tabItem {
                    Image(systemName: "tray.fill")
                    Text("Products")
                }
                .tag(1)
            
            TransactionsView()
                .tabItem {
                    Image(systemName: "receipt.fill")
                    Text("Transactions")
                }
                .tag(2)
        })
    }
}

#Preview {
    DashboardView()
}
