//
//  DateModalView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/24/25.
//

import SwiftUI

struct DateModalView: View {
    @Binding var isShow: Bool
    @Binding var selectedDate: Date?
    
    @State private var tempSelectedDate: Date = Date()

    private let startingDate: Date = Calendar.current.date(from: DateComponents(year: 2000)) ?? Date()
    private let endDate: Date = Date()
    
    var body: some View {
        ModalView(isShowModal: $isShow, content: Group {
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

                        isShow.toggle()
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
                        isShow.toggle()
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
}

#Preview {
    DateModalView(isShow: .constant(true), selectedDate: .constant(nil))
}
