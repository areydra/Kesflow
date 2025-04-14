//
//  AddProductView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/2/25.
//

import SwiftUI

struct AddProductView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(TabProductViewModel.self) private var tabProductViewModel

    let productService: ProductService = .init()
    let productSummaryService: ProductSummaryServiceProviding

    @State private var productName: String = ""
    @State private var recommendedPrice: String = ""
    @State private var listProductStock: [ProductStockEntity] = []

    func onSave() {
        Task {
            await tabProductViewModel.add(
                name: productName,
                recommendedPrice: Int32(unformatDecimal(text: recommendedPrice)) ?? 0,
                listProductStock: listProductStock
            )
            productSummaryService.refreshProductSummaryStock()
        }
        productSummaryService.refreshProductSummaryStock()
        dismiss()
    }

    var body: some View {
        ScrollView {
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 150, height: 100)
                    .foregroundStyle(.gray.opacity(0.5))
                    .padding(.bottom, 8)
                
                Button {
                    print(listProductStock)
                } label: {
                    Text("Upload Image")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
            .padding(.top, 36)
            
            VStack {
                TextFieldStringView(
                    label: "Product Name",
                    text: $productName,
                    placeholder: "Enter product name"
                )
                
                Divider().padding(.vertical, 4)
                
                ListInputProductStockView(listProductStock: $listProductStock)

                Divider().padding(.vertical, 4)
                
                TextFieldNumberView(
                    label: "Recommended price",
                    text: $recommendedPrice,
                    placeholder: "0",
                    isShowPrefixCurrency: true
                )
            }
            .padding(.horizontal, 26)
            .padding(.vertical, 20)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: onSave) {
                    Text("Save")
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)
                }
            }
        }
        .navigationTitle("Add Product")
        .onAppear() {
            listProductStock.append(productService.productStockEntity(costPrice: 0, stock: 0, unit: ""))
        }
    }
}

#Preview {
    NavigationStack {
        AddProductView(productSummaryService: ProductSummaryService())
            .environment(TabProductViewModel(productService: ProductService()))
    }
}
