//
//  InputProductStockListView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/4/25.
//

import SwiftUI

struct InputProductStockListView: View {
    @Binding private var listProductStock: [ProductStockModel]
    
    init(listProductStock: Binding<[ProductStockModel]>) {
        self._listProductStock = listProductStock
    }
    
    var body: some View {
        VStack {
            ForEach(0..<listProductStock.count, id: \.self) { index in
                InputProductStockView(index: index, productStockList: $listProductStock)

                if (listProductStock.count > 1) {
                    Divider().padding(.vertical, 4)
                }
            }
            
            Button {
                listProductStock.append(ProductStockModel(stock: 0, unit: "", costPrice: 0))
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

#Preview {
    InputProductStockListView(listProductStock: .constant([
        ProductStockModel(stock: 0, unit: "", costPrice: 0)
    ]))
}
