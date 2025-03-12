//
//  HomeView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 2/28/25.
//

import SwiftUI

struct ProductsView: View {
    @Environment(ProductsViewModel.self) var productsViewModel
    
    @State private var selectedProduct: ProductModel? = nil
    @State private var showAlertDelete: Bool = false
    
    @State private var draggingItemOffestX: CGFloat = 0
    @State private var draggedItemOffsetX: CGFloat = 0
    
    var body: some View {
        ScrollView {
            HStack {
                Text("List of Products")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Spacer()
                
                NavigationLink(
                    value: ViewKeys.AddProduct,
                    label: {
                        Image(systemName: "plus.app.fill")
                            .font(.title)
                            .foregroundStyle(.blue)
                    }
                )
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            LazyVStack() {
                if (productsViewModel.products.isEmpty) {
                    Text("Product is Empty. You can create a new product")
                } else {
                    ForEach(Array(productsViewModel.products.enumerated()), id: \.element.id) { index, product in
                        ZStack {
                            HStack {
                                Button {
                                    selectedProduct = product
                                    showAlertDelete.toggle()
                                } label: {
                                    Text("Delete")
                                        .frame(maxHeight: .infinity)
                                        .frame(width: 100)
                                        .background(.red)
                                        .foregroundStyle(.white)
                                        .font(.headline)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)

                            
                            HStack(alignment: .top) {
                                NavigationLink(destination: EditProductView(productId: product.id)) {
                                    RoundedRectangle(cornerRadius: 16)
                                        .frame(width: 100, height: 80)
                                        .padding(.trailing, 8)
                                    
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(product.name)
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                            Spacer()
                                            Text("Rp\(formatDecimalInThousand(text: String(product.recommendedPrice)))")
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                        }
                                        .padding(.bottom, 8)
                                        
                                        ForEach(product.listProductStock) { productStock in
                                            HStack {
                                                Text("Cost price: Rp\(formatDecimalInThousand(text: String( productStock.costPrice)))")
                                                    .font(.footnote)
                                                Spacer()
                                                Text("\(productStock.stock) \(productStock.unit)")
                                                    .font(.footnote)
                                            }
                                        }
                                    }
                                }
                                .foregroundStyle(.black)
                            }
                            .background(.white)
                            .offset(x: draggingItemOffestX)
                            .offset(x: draggedItemOffsetX)
                            .simultaneousGesture(
                                DragGesture()
                                    .onChanged { value in
                                        let fiftyPercentWidth =  UIScreen.main.bounds.width * 0.5

                                        if (abs(value.translation.width) <= fiftyPercentWidth) {
                                            draggingItemOffestX = value.translation.width
                                        }
                                    }
                                    .onEnded { value in
                                        withAnimation(.spring()) {
                                            if (draggedItemOffsetX != 0 && draggingItemOffestX < -50) {
                                                draggedItemOffsetX = 0
                                            } else if (draggingItemOffestX < -100) {
                                                draggedItemOffsetX = -108
                                            } else if (draggingItemOffestX > 50) {
                                                draggedItemOffsetX = 0
                                            }
                                            
                                            draggingItemOffestX = 0
                                        }
                                    }
                            )
                        }
                        
                        if ((productsViewModel.products.count - 1) != index) {
                            Divider()
                                .padding(.vertical, 8)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .alert(isPresented: $showAlertDelete) {
            Alert(
                title: Text("Delete \(selectedProduct?.name ?? "Product")"),
                primaryButton: .destructive(Text("Delete"), action: {
                    guard let selectedProduct = selectedProduct else { return }
                    productsViewModel.deleteProduct(product: selectedProduct)
                }),
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    NavigationStack {
        ProductsView()
    }
    .environment(ProductsViewModel())
}
