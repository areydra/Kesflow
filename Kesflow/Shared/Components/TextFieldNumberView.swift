//
//  TextFieldNumberView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/4/25.
//

import SwiftUI

struct TextFieldNumberView: View {
    @Binding private var text: String
    private var label: String
    private var placeholder: String
    private var isShowPrefixCurrency: Bool

    init(label: String, text: Binding<String>, placeholder: String, isShowPrefixCurrency: Bool = false) {
        self._text = text
        self.label = label
        self.placeholder = placeholder
        self.isShowPrefixCurrency = isShowPrefixCurrency
    }
    
    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 0) {
                if (isShowPrefixCurrency) {
                    Text("Rp")
                }

                TextField(placeholder, text: $text)
                    .onChange(of: text, { oldValue, newValue in
                        text = formatDecimalInThousand(text: newValue)
                    })
                    .font(.body)
                    .keyboardType(.decimalPad)
                    .padding(.vertical, 18)
            }
            .padding(.horizontal, 14)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

#Preview {
    TextFieldNumberView(
        label: "Label",
        text: .constant(""),
        placeholder: "Placeholder"
    )
}
