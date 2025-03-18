//
//  HomeView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 2/28/25.
//

import SwiftUI

struct TransactionsView: View {
    @Environment(TransactionViewModel.self) var transactionViewModel
 
    var body: some View {
        ScrollView {
            HStack {
                Text("Transaction list")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Spacer()
                    
                NavigationLink(value: ViewKeys.AddTransaction) {
                    Image(systemName: "plus.app.fill")
                        .font(.title)
                        .foregroundStyle(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            LazyVStack() {
                if transactionViewModel.transactions.isEmpty {
                    Text("There are no transactions!")
                } else {
                    ForEach(transactionViewModel.transactions) { transaction in
                        ItemTransactionView(transaction: transaction)
                    }

                }
            }
        }
    }
}

#Preview {
    TransactionsView()
        .environment(TransactionViewModel(context: DatabaseViewModel().context))
}
