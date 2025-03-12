//
//  EditProductView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/2/25.
//

import SwiftUI

struct EditProductView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(ProductsViewModel.self) var productsViewModel
    
    @State private var productName: String = ""
    @State private var recommendedPrice: String = ""
    @State private var listProductStock: [ProductStockModel] = [
        ProductStockModel(stock: 0, unit: "", costPrice: 0)
    ]

    let productId: String
    
    init(productId: String = "") {
        self.productId = productId
    }


    func getProductDetail() {
        guard let product = productsViewModel.getSpecificProduct(id: productId) else { return }

        productName = product.name
        recommendedPrice = product.recommendedPrice.description
        listProductStock = product.listProductStock
    }

    func onSave() {
        productsViewModel.editProduct(
            product: ProductModel(
                id: productId,
                name: productName,
                recommendedPrice: Int(unformatDecimal(text: recommendedPrice)) ?? 0,
                listProductStock: listProductStock
            )
        )
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
                
                InputProductStockListView(listProductStock: $listProductStock)

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
        .onAppear(perform: getProductDetail)
        .navigationTitle("Add Product")
    }
}

#Preview {
    NavigationStack {
        EditProductView()
    }
    .environment(ProductsViewModel())
}
