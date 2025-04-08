//
//  ItemTransactionView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/17/25.
//

import SwiftUI

struct ItemTransactionView: View {
    @Environment(NavigationViewModel.self) var navigationViewModel
    @State private var transactionViewModel: TransactionViewModel = .instance

    var transaction: TransactionEntity
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        return formatter
    }
    
    @State private var showAlertDelete: Bool = false
    @State private var draggingItemOffestX: CGFloat = 0
    @State private var draggedItemOffsetX: CGFloat = 0

    var body: some View {
        ZStack {
            HStack {
                Button {
                    showAlertDelete.toggle()
                } label: {
                    Text("Delete")
                        .frame(maxHeight: .infinity)
                        .frame(width: 100)
                        .background(.red)
                        .foregroundStyle(.white)
                        .font(.headline)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            HStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 100, height: 80)
                    .padding(.trailing, 8)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(transaction.name ?? "")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color("TextPrimary"))
                        Spacer()
                        Text("Sold \(transaction.quantity) \(transaction.unit ?? "")")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color("TextPrimary"))
                    }
                    .padding(.bottom, 8)
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text("Cost price: Rp\(formatDecimalInThousand(text: String(transaction.costPrice)))")
                                .font(.footnote)
                                .foregroundStyle(Color("TextPrimary"))
                            Text("Sale price: Rp\(formatDecimalInThousand(text: String(transaction.salePrice)))")
                                .font(.footnote)
                                .foregroundStyle(Color("TextPrimary"))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            VStack(alignment: .trailing) {
                                Text("Total cost price:")
                                    .font(.footnote)
                                    .foregroundStyle(Color("TextPrimary"))
                                Text("Rp\(formatDecimalInThousand(text: String(transaction.totalSalePrice - transaction.profit)))")
                                    .font(.footnote)
                                    .bold()
                                    .foregroundStyle(Color("TextPrimary"))
                            }
                            VStack(alignment: .trailing) {
                                Text("Total sale price:")
                                    .font(.footnote)
                                    .foregroundStyle(Color("TextPrimary"))
                                Text("Rp\(formatDecimalInThousand(text: String(transaction.totalSalePrice)))")
                                    .font(.footnote)
                                    .bold()
                                    .foregroundStyle(Color("TextPrimary"))
                            }
                            VStack(alignment: .trailing) {
                                Text("Profit:")
                                    .font(.footnote)
                                    .foregroundStyle(Color("TextPrimary"))
                                Text("Rp\(formatDecimalInThousand(text: String(transaction.profit)))")
                                    .font(.footnote)
                                    .bold()
                                    .foregroundStyle(Color("TextPrimary"))
                            }
                        }
                    }
                    .padding(.bottom, 4)
                    
                    Text(dateFormatter.string(from: transaction.createdAt ?? Date()))
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundStyle(Color("TextPrimary"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            .background(Color("ItemBackground"))
            .offset(x: draggingItemOffestX)
            .offset(x: draggedItemOffsetX)
            .onTapGesture(perform: {
                transactionViewModel.setSelectedTransaction(transaction)
                navigationViewModel.push(.EditTransaction)
            })
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        let fiftyPercentWidth =  UIScreen.main.bounds.width * 0.5
                        
                        if (abs(value.translation.width) <= fiftyPercentWidth) {
                            draggingItemOffestX = value.translation.width
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            if (draggedItemOffsetX != 0 && draggingItemOffestX < -50) {
                                draggedItemOffsetX = 0
                            } else if (draggingItemOffestX < -100) {
                                draggedItemOffsetX = -108
                            } else if (draggingItemOffestX > 50) {
                                draggedItemOffsetX = 0
                            }
                            
                            draggingItemOffestX = 0
                        }
                    }
            )
            .alert(isPresented: $showAlertDelete) {
                Alert(
                    title: Text("Delete \(transaction.name ?? "Transaction")"),
                    primaryButton: .destructive(Text("Delete"), action: {
                        transactionViewModel.deleteTransaction(transaction)
                    }),
                    secondaryButton: .cancel()
                )
            }
        }
        Divider()
            .padding(.bottom, 8)
    }
}

struct ItemTransactionView_Views: PreviewProvider {
    static var previews: some View {
        let context = DatabaseViewModel.instance.context
        let transactionEntity: TransactionEntity = TransactionEntity(context: context)
        let productStock = ProductStockEntity(context: context)
        
        transactionEntity.name = "Bening 600ml"
        transactionEntity.quantity = 10
        transactionEntity.salePrice = 24000
        transactionEntity.totalSalePrice = 240000
        transactionEntity.createdAt = Date()
        transactionEntity.costPrice = 19500
        transactionEntity.note = ""
        transactionEntity.unit = "Dus"
        transactionEntity.profit = 45000
        transactionEntity.productStock = productStock

        return ItemTransactionView(transaction: transactionEntity)
            .environment(NavigationViewModel())
    }
}
