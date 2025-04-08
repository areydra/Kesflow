//
//  ListProductBottomSheetView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/24/25.
//

import SwiftUI

struct ListProductBottomSheetView: View {
    @State private var listProductViewModel: ListProductViewModel = .instance

    @Binding var isShow: Bool
    @Binding var selectedProduct: ProductEntity?
    @Binding var selectedProductStock: ProductStockEntity?

    var body: some View {
        BottomSheet(isShowModal: $isShow, content: Group {
            VStack {
                if listProductViewModel.products.isEmpty {
                    Text("No product found")
                } else {
                    List {
                        ForEach(listProductViewModel.products, id: \.self) { product in
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
    }
}

struct ListProductBottomSheetView_Preview: PreviewProvider {
    static var previews: some View {
        ListProductBottomSheetView(isShow: .constant(true), selectedProduct: .constant(nil), selectedProductStock: .constant(nil))
    }
}
