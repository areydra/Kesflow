//
//  ProductSummaryView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 4/3/25.
//

import SwiftUI

struct ProductSummaryView: View {
    @StateObject private var productSummaryViewModel: ProductSummaryViewModel = .instance

    var dateFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"

        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Product Stock")
                    .font(.title3)
                    .padding(.bottom, 8)
                    .bold()
                
                VStack(alignment: .leading) {
                    Text("Product in Stock:")
                        .font(.caption)
                    Text("\(productSummaryViewModel.productSummaryStock?.totalProductStock ?? 0)")
                        .font(.headline)
                }
                .padding(.bottom, 4)
                
                VStack(alignment: .leading) {
                    Text("Money in Stock:")
                        .font(.caption)
                    Text("Rp\(formatDecimalInThousand(text: String(productSummaryViewModel.productSummaryStock?.totalMoneyInStock ?? 0)))")
                        .font(.headline)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(radius: 8, x: 0, y: 6)
            .padding(.bottom, 24)

            HStack {
                Text(dateFormat.string(from: productSummaryViewModel.productSummarySales?.date ?? Date()))
                Spacer()
                Image(systemName: "calendar.circle.fill")
                    .font(.title)
                    .foregroundStyle(.blue)
                    .onTapGesture {
                        productSummaryViewModel.showCalendarModal()
                    }
            }
            .padding(.bottom, 8)

            Grid {
                GridRow {
                    
                    VStack(alignment: .leading) {
                        Text("Product Sold")
                            .font(.title3)
                            .padding(.bottom, 8)
                            .bold()
                        
                        VStack(alignment: .leading) {
                            Text("Total Product Sold:")
                                .font(.caption)
                            Text("\(productSummaryViewModel.productSummarySales?.totalProductsSold ?? 0)")
                                .font(.headline)
                        }
                        .padding(.bottom, 4)
                        
                        VStack(alignment: .leading) {
                            Text("Sales Revenue:")
                                .font(.caption)
                            Text("Rp\(formatDecimalInThousand(text: String(productSummaryViewModel.productSummarySales?.totalSalesRevenue ?? 0)))")
                                .font(.headline)
                        }
                        .padding(.bottom, 4)
                        
                        VStack(alignment: .leading) {
                            Text("Profit:")
                                .font(.caption)
                            Text("Rp\(formatDecimalInThousand(text: String(productSummaryViewModel.productSummarySales?.totalProfit ?? 0)))")
                                .font(.headline)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(radius: 8, x: 0, y: 6)
                }
                .padding(.bottom, 16)
            }
        }
        .padding()
    }
}

#Preview {
    ProductSummaryView()
}
