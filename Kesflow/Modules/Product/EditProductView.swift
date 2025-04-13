//
//  EditProductView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/2/25.
//

import SwiftUI

struct EditProductView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var productSummaryViewModel: ProductSummaryViewModel
    
    @State private var listProductViewModel: TabProductViewModel = .instance
    
    @State private var productName: String = ""
    @State private var recommendedPrice: String = ""
    @State private var listProductStock: [ProductStockEntity] = []

    func getProductDetail() {
        guard let selectedProduct = listProductViewModel.selectedProduct else {
            return
        }
        
        productName = selectedProduct.name ?? ""
        recommendedPrice = selectedProduct.recommendedPrice == 0 ? "" : selectedProduct.recommendedPrice.description
        
        if let productStock = selectedProduct.listProductStock as? Set<ProductStockEntity> {
            listProductStock = Array(productStock)
        }
    }

    func onSave() {
        Task {
            try await listProductViewModel.editProduct(
                newName: productName,
                newRecommendedPrice: Int32(recommendedPrice.isEmpty ? "0" : unformatDecimal(text: recommendedPrice)) ?? 0,
                listProductStock: listProductStock
            )
            productSummaryViewModel.refreshProductSummaryStock()
        }
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
                .onChange(of: productName) { oldValue, newValue in
                    guard let selectedProduct = listProductViewModel.selectedProduct else { return }
                    selectedProduct.name = newValue
                }
                
                Divider().padding(.vertical, 4)
                
                ListInputProductStockView(listProductStock: $listProductStock)

                Divider().padding(.vertical, 4)
                
                TextFieldNumberView(
                    label: "Recommended price",
                    text: $recommendedPrice,
                    placeholder: "0",
                    isShowPrefixCurrency: true
                )
                .onChange(of: recommendedPrice) { oldValue, newValue in
                    guard let selectedProduct = listProductViewModel.selectedProduct else { return }
                    selectedProduct.recommendedPrice = Int32(unformatDecimal(text: recommendedPrice)) ?? 0
                }
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
        .onAppear(perform: getProductDetail)
        .onDisappear(perform: listProductViewModel.removeSelectedProduct)
        .navigationTitle("Edit Product")
    }
}

#Preview {
    NavigationStack {
        EditProductView()
    }
}
