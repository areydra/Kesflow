//
//  TabHomeView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 2/28/25.
//

import SwiftUI

struct TabHomeView: View {
    @EnvironmentObject var productSummaryViewModel: ProductSummaryViewModel
    
    var body: some View {
        ZStack {
            ScrollView {
                HStack {
                    Text("Dashboard")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                ProductSummaryView()
            }
            DateModalView(isShow: $productSummaryViewModel.isShowCalendarModal, selectedDate: $productSummaryViewModel.selectedDate)
        }
    }
}

#Preview {
    TabHomeView()
        .environmentObject(ProductSummaryViewModel(context: DatabaseViewModel().context))
}
