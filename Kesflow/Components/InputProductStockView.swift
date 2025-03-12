//
//  InputProductStockView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/2/25.
//

import SwiftUI

struct InputProductStockView: View {
    private let index: Int
    @Binding private var productStockList: [ProductStockModel]

    @State private var stock: String = ""
    @State private var unit: String = ""
    @State private var costPrice: String = ""
    
    init(index: Int, productStockList: Binding<[ProductStockModel]>) {
        self.index = index
        self._productStockList = productStockList
    }
    
    // We cannot set the state value inside init(), because init and view are initializing in parallel.
    // i.e.: Even though the state value has been set from the init(), it will not reflect in the UI because SwiftUI only listens to @State value changes when they originate from the view hierarchy. In this case, using onAppear() ensures the changes are reflected in the UI.
    func getLocalValue() {
        unit = productStockList[index].unit
        stock = productStockList[index].stock > 0 ? String(productStockList[index].stock) : ""
        costPrice = productStockList[index].costPrice > 0 ? String(productStockList[index].costPrice) : ""
    }

    var body: some View {
        VStack {
            HStack {
                TextFieldNumberView(
                    label: "Stock",
                    text: $stock,
                    placeholder: "0"
                )
                .onChange(of: stock, { oldValue, newValue in
                    if let stockValue = Int(unformatDecimal(text: newValue)) {
                        productStockList[index].stock = stockValue
                    }
                })
                TextFieldStringView(
                    label: "Unit",
                    text: $unit,
                    placeholder: "Box/Pcs/Pack"
                )
                .onChange(of: unit, { oldValue, newValue in
                    productStockList[index].unit = newValue
                })
            }
            .padding(.bottom, 8)

            TextFieldNumberView(
                label: "Cost price",
                text: $costPrice,
                placeholder: "0",
                isShowPrefixCurrency: true
            )
            .onChange(of: costPrice, { oldValue, newValue in
                if let costPriceValue = Int(unformatDecimal(text: newValue)) {
                    productStockList[index].costPrice = costPriceValue
                }
            })
        }
        .onAppear(perform: getLocalValue)
    }
}

#Preview {
    InputProductStockView(index: 0, productStockList: .constant([ProductStockModel(stock: 10, unit: "Box", costPrice: 1000)]))
}
