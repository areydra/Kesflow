//
//  AddTransactionView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/14/25.
//

import SwiftUI

struct AddTransactionView: View {
    @Environment(ListProductViewModel.self) var listProductViewModel
    @Environment(TransactionViewModel.self) var transactionViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var salePrice: String = ""
    @State var quantity: String = ""
    @State var note: String = ""
    
    @State var isShowModalDate: Bool = false
    @State var isShowProductBS: Bool = false
    @State var isShowProductStockBS: Bool = false

    @State var selectedDate: Date? = nil
    @State var selectedProduct: ProductEntity? = nil
    @State var selectedProductStock: ProductStockEntity? = nil

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        return formatter
    }

    func saveTransaction() {
        guard let product = selectedProduct,
              let productStock = selectedProductStock else { return }
        
        let unFormatSalePrice: Int32 = Int32(unformatDecimal(text: salePrice)) ?? 0
        let unFormatQuantity: Int32 = Int32(unformatDecimal(text: quantity)) ?? 0

        transactionViewModel.saveTransaction(
            TransactionModel(
                name: product.name ?? "",
                quantity: Int16(unFormatQuantity),
                salePrice: unFormatSalePrice,
                totalSalePrice: unFormatSalePrice * unFormatQuantity,
                date: selectedDate ?? Date(),
                costPrice: productStock.costPrice,
                note: note,
                unit: productStock.unit ?? "",
                profit: (unFormatSalePrice * unFormatQuantity) - (productStock.costPrice * unFormatQuantity),
                productStock: productStock
            )
        )

        dismiss()
    }

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 150, height: 100)

                    TextFieldSelectView(
                        label: "Product",
                        placeholder: selectedProduct?.name ?? "Click to search product",
                        imageSystemName: "magnifyingglass",
                        onPress: {
                            withAnimation {
                                isShowProductBS.toggle()
                            }
                        }
                    )
                    .padding(.top, 20)
                    
                    TextFieldSelectView(
                        label: "Cost price",
                        placeholder: selectedProductStock == nil ? "Select cost price" : "Rp\(formatDecimalInThousand(text: String(selectedProductStock?.costPrice ?? 0)))",
                        imageSystemName: "chevron.down.circle",
                        onPress: {
                            isShowProductStockBS.toggle()
                        }
                    )
                    .padding(.top, 8)

                    TextFieldNumberView(label: "Sale price", text: $salePrice, placeholder: "0", isShowPrefixCurrency: true)
                    .padding(.top, 8)

                    TextFieldStringView(label: "Quantity", text: $quantity, placeholder: "0")
                    .padding(.top, 8)

                    TextFieldSelectView(
                        label: "Date",
                        placeholder: selectedDate != nil ? dateFormatter.string(from: selectedDate ?? Date()) : "Select date transaction",
                        imageSystemName: "calendar",
                        onPress: {
                            isShowModalDate.toggle()
                        }
                    )
                    .padding(.top, 8)

                    TextEditorView(label: "Note", text: $note)
                    .padding(.top, 8)
                }
                .padding(.horizontal, 26)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }

            DateModalView(isShow: $isShowModalDate, selectedDate: $selectedDate)
            ListProductBottomSheetView(isShow: $isShowProductBS, selectedProduct: $selectedProduct, selectedProductStock: $selectedProductStock)
            ListProductStockBottomSheetView(isShow: $isShowProductStockBS, selectedProduct: $selectedProduct, selectedProductStock: $selectedProductStock)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: saveTransaction) {
                    Text("Save").fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddTransactionView()
    }
    .environment(ListProductViewModel(context: DatabaseViewModel().context))
    .environment(TransactionViewModel(context: DatabaseViewModel().context))
}
