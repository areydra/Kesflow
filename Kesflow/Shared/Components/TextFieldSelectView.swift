//
//  TextFieldSelectView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/14/25.
//

import SwiftUI

struct TextFieldSelectView: View {
    private var label: String
    private var placeholder: String
    private var imageSystemName: String
    private var onPress: (() -> Void)?
    private var disabled: Bool

    init(label: String, placeholder: String, imageSystemName: String = "", onPress: (() -> Void)? = nil, disabled: Bool = false) {
        self.label = label
        self.placeholder = placeholder
        self.imageSystemName = imageSystemName
        self.onPress = onPress
        self.disabled = disabled
    }
    
    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                onPress?()
            } label: {
                HStack {
                    Text(placeholder)
                        .foregroundStyle(.black.opacity(0.6))
                    Spacer()
                    Image(systemName: imageSystemName)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 18)
                .padding(.horizontal, 14)
                
            }
            .background(.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .disabled(disabled)
        }
    }
}

#Preview {
    TextFieldSelectView(
        label: "Label",
        placeholder: "Placeholder",
        imageSystemName: "magnifyingglass"
    )
}
