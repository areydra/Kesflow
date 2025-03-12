//
//  HomeView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 2/28/25.
//

import SwiftUI

struct TransactionsView: View {
    var body: some View {
        ScrollView {
            HStack {
                Text("Transaction list")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Image(systemName: "plus.app.fill")
                    .font(.title)
                    .foregroundStyle(.blue)
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            LazyVStack() {
                ForEach(0..<100) { _ in
                    HStack {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 100, height: 80)
                            .padding(.trailing, 8)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Aqua 500ml")
                                    .font(.headline)
                                Spacer()
                                Text("Stock 50 Box")
                                    .font(.headline)
                            }
                            .padding(.bottom, 8)
                            
                            HStack(alignment: .top) {
                                VStack {
                                    Text("Cost price: Rp32.0000")
                                        .font(.caption)
                                    Text("Sale price: Rp35.0000")
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text("Total sale price:")
                                        .font(.caption)
                                    Text("Rp32.0000")
                                        .font(.caption)
                                }
                            }
                            .padding(.bottom, 4)
                            
                            Text("26 February 2025")
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .foregroundStyle(.green)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    
                    Divider()
                        .padding(.bottom, 8)
                }
            }
        }
    }
}

#Preview {
    TransactionsView()
}
