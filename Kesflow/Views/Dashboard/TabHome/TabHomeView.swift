//
//  TabHomeView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 2/28/25.
//

import SwiftUI

struct TabHomeView: View {
    @StateObject private var productSummaryViewModel: ProductSummaryViewModel = .instance
    
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
}
