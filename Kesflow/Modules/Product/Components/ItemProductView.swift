//
//  ItemProductView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/13/25.
//

import SwiftUI

struct ItemProductView: View {
    @Environment(NavigationViewModel.self) private var navigationViewModel
    
    @ObservedObject var product: ProductEntity
    @State var tabProductViewModel: TabProductViewModel
    let productSummaryService: ProductSummaryServiceProviding
    
    @State private var selectedProduct: ProductEntity? = nil
    @State private var showAlertDelete: Bool = false
    @State private var draggingItemOffestX: CGFloat = 0
    @State private var draggedItemOffsetX: CGFloat = 0

    var body: some View {
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
                RoundedRectangle(cornerRadius: 16)
                  .frame(width: 100, height: 80)
                  .padding(.trailing, 8)
                
                VStack(alignment: .leading) {
                    HStack {
                      Text(product.name ?? "")
                          .font(.subheadline)
                          .fontWeight(.semibold)
                          .foregroundStyle(Color("TextPrimary"))
                      Spacer()
                      Text("Rp\(formatDecimalInThousand(text: String(product.recommendedPrice)))")
                          .font(.subheadline)
                          .fontWeight(.semibold)
                          .foregroundStyle(Color("TextPrimary"))
                    }
                    .padding(.bottom, 8)

                    if let listProductStock = product.listProductStock?.allObjects as? [ProductStockEntity] {
                        ForEach(listProductStock) { productStock in
                            ItemProductStockView(productStock: productStock)
                        }
                    }
                }
            }
            .background(Color("ItemBackground"))
            .offset(x: draggingItemOffestX)
            .offset(x: draggedItemOffsetX)
            .onTapGesture(perform: {
                tabProductViewModel.setSelectedProduct(product: product)
                navigationViewModel.push(.EditProduct)
            })
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
        .alert(isPresented: $showAlertDelete) {
            Alert(
                title: Text("Delete \(selectedProduct?.name ?? "Product")"),
                primaryButton: .destructive(Text("Delete"), action: {
                    guard let selectedProduct = selectedProduct else { return }
                    Task {
                        await tabProductViewModel.delete(product: selectedProduct)
                        productSummaryService.refreshProductSummaryStock()
                    }
                }),
                secondaryButton: .cancel()
            )
        }
    }
}

private struct ItemProductStockView: View {
    @ObservedObject var productStock: ProductStockEntity
    
    var body: some View {
        HStack {
            Text("Cost price: Rp\(formatDecimalInThousand(text: String(productStock.costPrice)))")
                .font(.footnote)
                .foregroundStyle(Color("TextPrimary"))
            Spacer()
            Text("\(productStock.stock) \(productStock.unit ?? "")")
                .font(.footnote)
                .foregroundStyle(Color("TextPrimary"))
        }
    }
}


struct ItemProductView_Views: PreviewProvider {
    static var previews: some View {
        let context = KesflowManager.instance.context
        let productEntity: ProductEntity = ProductEntity(context: context)
        let productStock = ProductStockEntity(context: context)
        var listProductStock: [ProductStockEntity] = []

        productStock.costPrice = 20000
        productStock.stock = 20
        productStock.unit = "Dus"
        listProductStock.append(contentsOf: [productStock])
        
        productEntity.name = "Lee Mineral 500ml"
        productEntity.recommendedPrice = 21000
        productEntity.listProductStock = NSSet(array: listProductStock)

        return ItemProductView(
                product: productEntity,
                tabProductViewModel: TabProductViewModel(productService: ProductService()),
                productSummaryService: ProductSummaryService()
            )
            .environment(NavigationViewModel())
    }
}
