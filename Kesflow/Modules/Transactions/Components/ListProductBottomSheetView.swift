//
//  ListProductBottomSheetView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/24/25.
//

import SwiftUI

struct ListProductBottomSheetView: View {
    @Binding var isShow: Bool
    @Binding var selectedProduct: ProductEntity?
    @Binding var selectedProductStock: ProductStockEntity?
    
    @State var products: [ProductEntity] = []
    
    let productService: ProductServiceProviding
    
    init(
        isShow: Binding<Bool>,
        selectedProduct: Binding<ProductEntity?> = .constant(nil),
        selectedProductStock: Binding<ProductStockEntity?> = .constant(nil),
        productService: ProductServiceProviding
    ) {
        self._isShow = isShow
        self._selectedProduct = selectedProduct
        self._selectedProductStock = selectedProductStock
        self.productService = productService
    }

    var body: some View {
        BottomSheet(isShowModal: $isShow, content: Group {
            VStack {
                if products.isEmpty {
                    Text("No product found")
                } else {
                    List {
                        ForEach(products, id: \.self) { product in
                            Text(product.name ?? "")
                                .onTapGesture {
                                    if (selectedProduct != product) {
                                        selectedProductStock = nil
                                    }
                                    
                                    selectedProduct = product
                                    isShow.toggle()
                                }
                        }
                    }
                    .frame(maxHeight: 500)
                    .listStyle(.plain)
                }
            }
        })
        .onAppear {
            if let products = productService.get() {
                self.products = products
            }
        }
    }
}

struct ListProductBottomSheetView_Preview: PreviewProvider {
    static var previews: some View {
        ListProductBottomSheetView(
            isShow: .constant(true),
            selectedProduct: .constant(nil),
            selectedProductStock: .constant(nil),
            productService: ProductService()
        )
    }
}
