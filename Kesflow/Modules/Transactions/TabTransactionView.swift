//
//  HomeView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 2/28/25.
//

import SwiftUI

struct TabTransactionView: View {
    @Environment(TabTransactionViewModel.self) private var tabTransactionViewModel
    let productSummaryService: ProductSummaryServiceProviding
 
    var body: some View {
        ScrollView {
            HStack {
                Text("Transaction list")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Spacer()
                    
                NavigationLink(value: NavigationKey.AddTransaction) {
                    Image(systemName: "plus.app.fill")
                        .font(.title)
                        .foregroundStyle(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            LazyVStack() {
                if tabTransactionViewModel.transactions.isEmpty {
                    Text("There are no transactions!")
                } else {
                    ForEach(tabTransactionViewModel.transactions) { transaction in
                        ItemTransactionView(
                            transaction: transaction,
                            tabTransactionViewModel: tabTransactionViewModel,
                            productSummaryService: productSummaryService
                        )
                    }

                }
            }
        }
    }
}

#Preview {
    TabTransactionView(productSummaryService: ProductSummaryService())
        .environment(TabTransactionViewModel())
}
