//
//  ListProductStockBottomSheetView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/24/25.
//

import SwiftUI

struct ListProductStockBottomSheetView: View {
    @Binding var isShow: Bool
    @Binding var selectedProduct: ProductEntity?
    @Binding var selectedProductStock: ProductStockEntity?
    
    var body: some View {
        BottomSheet(isShowModal: $isShow, content: Group {
            VStack {
                if let listProductStock = selectedProduct?.listProductStock?.allObjects as? [ProductStockEntity] {
                    List {
                        ForEach(listProductStock) { productStock in
                            Text("Rp\(formatDecimalInThousand(text: String( productStock.costPrice)))")
                                .onTapGesture {
                                    selectedProductStock = productStock
                                    isShow.toggle()
                                }
                        }
                    }
                    .frame(maxHeight: 500)
                    .listStyle(.plain)
                } else {
                    Text("Select product first")
                }
            }
        })
    }
}

struct ListProductStockBottomSheetView_Preview: PreviewProvider {
    static var previews: some View {
        @State var isShow: Bool = true
        @State var selectedProduct: ProductEntity? = nil
        @State var selectedProductStock: ProductStockEntity? = nil

        ListProductStockBottomSheetView(
            isShow: $isShow,
            selectedProduct: $selectedProduct,
            selectedProductStock: $selectedProductStock
        )
    }
}
