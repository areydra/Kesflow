//
//  HomeView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 2/28/25.
//

import SwiftUI

struct TabProductView: View {
    @State private var listProductViewModel: TabProductViewModel = .instance

    var body: some View {
        ScrollView {
            HStack {
                Text("List of Products")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Spacer()
                
                NavigationLink(
                    value: NavigationKey.AddProduct,
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
                if (listProductViewModel.products.isEmpty) {
                    Text("Product is Empty. You can create a new product")
                } else {
                    ForEach(listProductViewModel.products) { product in
                        ItemProductView(product: product)

                        if (listProductViewModel.products.last?.id != product.id) {
                            Divider().padding(.vertical, 8)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationStack {
        TabProductView()
    }
}
