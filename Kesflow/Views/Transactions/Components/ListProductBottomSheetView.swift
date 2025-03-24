//
//  ListProductBottomSheetView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/24/25.
//

import SwiftUI

struct ListProductBottomSheetView: View {
    @Environment(ListProductViewModel.self) var listProductViewModel

    @Binding var isShow: Bool
    @Binding var selectedProduct: ProductEntity?

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
                                    selectedProduct = product
                                    isShow.toggle()
                                }
                        }
                    }
                    .frame(maxHeight: 500)
                    .listStyle(.plain)
                }
            }.onAppear() {
                print("BS asdacq")
            }
        })
    }
}

struct ListProductBottomSheetView_Preview: PreviewProvider {
    static var previews: some View {
        let context = DatabaseViewModel().context
        @State var isShow = true
        @State var product: ProductEntity? = nil
        
        ListProductBottomSheetView(isShow: $isShow, selectedProduct: $product)
            .environment(ListProductViewModel(context: context))
    }
}
