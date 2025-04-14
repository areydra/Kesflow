//
//  ListInputProductStockView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/4/25.
//

import SwiftUI

struct ListInputProductStockView: View {
    @Binding var listProductStock: [ProductStockEntity]
    
    let productService: ProductService = .init()
    
    var body: some View {
        VStack {
            ForEach(listProductStock) { productStock in
                InputProductStockView(productStock: productStock)
                
                if (listProductStock.count > 1) {
                    Divider().padding(.vertical, 4)
                }
            }
            
            Button {
                listProductStock.append(
                    productService.productStockEntity(
                        costPrice: 0,
                        stock: 0,
                        unit: ""
                    )
                )
            } label: {
                Text("Add New")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .foregroundStyle(.white)
                    .padding(.top, 10)
            }

        }
    }
}

private struct InputProductStockView: View {
    let productStock: ProductStockEntity

    @State private var stock: String = ""
    @State private var unit: String = ""
    @State private var costPrice: String = ""
    
    // We cannot set the state value inside init(), because init and view are initializing in parallel.
    // i.e.: Even though the state value has been set from the init(), it will not reflect in the UI because SwiftUI only listens to @State value changes when they originate from the view hierarchy. In this case, using onAppear() ensures the changes are reflected in the UI.
    func getLocalValue() {
        unit = productStock.unit ?? ""
        stock = productStock.stock == 0 ? "" : productStock.stock.description
        costPrice = productStock.costPrice == 0 ? "" : productStock.costPrice.description
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
                    if let stockValue = Int16(unformatDecimal(text: newValue)) {
                        productStock.stock = stockValue
                    }
                })
                TextFieldStringView(
                    label: "Unit",
                    text: $unit,
                    placeholder: "Box/Pcs/Pack"
                )
                .onChange(of: unit, { oldValue, newValue in
                    productStock.unit = newValue
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
                if let costPriceValue = Int32(unformatDecimal(text: newValue)) {
                    productStock.costPrice = costPriceValue
                }
            })
        }
        .onAppear(perform: getLocalValue)
    }
}


#Preview {
    ListInputProductStockView(listProductStock: .constant([ProductStockEntity()]))
}
