//
//  ModalView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/14/25.
//

import SwiftUI

struct ModalView<ChildView: View>: View {
    @Binding var isShowModal: Bool
    @ViewBuilder var content: ChildView
    
    init(isShowModal: Binding<Bool>, content: ChildView = VStack {}) {
        self._isShowModal = isShowModal
        self.content = content
    }
    
    var body: some View {
        VStack {
            if isShowModal {
                ZStack {
                    Color.gray.opacity(0.3)
                        .onTapGesture {
                            withAnimation {
                                isShowModal.toggle()
                            }
                        }
                    
                    content
                }
            }
        }
        .animation(.linear, value: isShowModal)
    }
}

#Preview {
    ModalView(isShowModal: .constant(true))
}

