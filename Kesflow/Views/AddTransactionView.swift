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

    @State var tempSelectedDate: Date = Date()
    @State var selectedDate: Date? = nil
    
    @State var selectedProduct: ProductEntity? = nil
    @State var selectedProductStock: ProductStockEntity? = nil

    let startingDate: Date = Calendar.current.date(from: DateComponents(year: 2000)) ?? Date()
    let endDate: Date = Date()
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        return formatter
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

            BottomSheet(isShowModal: $isShowProductStockBS, content: Group {
                VStack {
                    if let listProductStock = selectedProduct?.listProductStock?.allObjects as? [ProductStockEntity] {
                        List {
                            ForEach(listProductStock) { productStock in
                                Text("Rp\(formatDecimalInThousand(text: String( productStock.costPrice)))")
                                    .onTapGesture {
                                        selectedProductStock = productStock
                                        isShowProductStockBS.toggle()
                                    }
                            }
                        }
                        .frame(maxHeight: 500)
                        .listStyle(.plain)
                    } else {
                        Text("Select product first")
                    }
                }.onAppear() {
                    print("BS asdacq")
                }
            })
            BottomSheet(isShowModal: $isShowProductBS, content: Group {
                VStack {
                    if listProductViewModel.products.isEmpty {
                        Text("No product found")
                    } else {
                        List {
                            ForEach(listProductViewModel.products, id: \.self) { product in
                                Text(product.name ?? "")
                                    .onTapGesture {
                                        selectedProduct = product
                                        isShowProductBS.toggle()
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
            ModalView(isShowModal: $isShowModalDate, content: Group {
                VStack {
                    DatePicker(
                        "Select a date",
                        selection: $tempSelectedDate,
                        in: startingDate...endDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    
                    HStack {
                        Button {
                            if let selectedDateByUser = selectedDate {
                                tempSelectedDate = selectedDateByUser
                            } else {
                                tempSelectedDate = Date()
                            }

                            isShowModalDate.toggle()
                        } label: {
                            Text("Cancel")
                                .foregroundStyle(.white)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .frame(width: 90)
                                .background(.red.opacity(0.9))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        Spacer()
                        Button {
                            selectedDate = tempSelectedDate
                            isShowModalDate.toggle()
                        } label: {
                            Text("Save")
                                .foregroundStyle(.white)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .frame(width: 90)
                                .background(.blue.opacity(0.9))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                    }
                    .padding(.bottom)
                }
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
                .onAppear() {
                    print("Date Appears")
                }
            })
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    if let product = selectedProduct {
                        if let productStock = selectedProductStock {
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
                    }
                }
                .fontWeight(.semibold)
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
