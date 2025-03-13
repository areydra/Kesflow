//
//  InputProductStockListView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/4/25.
//

import SwiftUI

struct InputProductStockListView: View {
    @Environment(ListProductViewModel.self) var listProductViewModel
    @Binding var listProductStock: [ProductStockEntity]
    
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
                    listProductViewModel.productStockEntity(
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

#Preview {
    InputProductStockListView(listProductStock: .constant([ProductStockEntity()]))
}
