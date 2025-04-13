//
//  ModalView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/14/25.
//

import SwiftUI

struct BottomSheet<ChildView: View>: View {
    @Binding var isShowModal: Bool
    @ViewBuilder var content: ChildView
    
    init(isShowModal: Binding<Bool>, content: ChildView = VStack {}) {
        self._isShowModal = isShowModal
        self.content = content
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isShowModal {
                Color.gray.opacity(0.2)
                    .onTapGesture {
                        withAnimation {
                            isShowModal.toggle()
                        }
                    }
            }
            
            VStack {
                if isShowModal {
                    VStack {
                        VStack {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 50, height: 8)
                                .foregroundStyle(.gray.opacity(0.5))
                                .padding(.vertical)
                        }
                        content
                    }
                    .frame(minHeight: 150, alignment: .top)
                    .transition(.move(edge: .bottom))
                }
            }
            .frame(maxWidth: .infinity)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .transition(.move(edge: .bottom))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .animation(.linear, value: isShowModal)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    BottomSheet(isShowModal: .constant(true))
}

