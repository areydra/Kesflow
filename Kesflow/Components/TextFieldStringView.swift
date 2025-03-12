//
//  TextFieldStringView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/4/25.
//

import SwiftUI

struct TextFieldStringView: View {
    @Binding private var text: String
    private var label: String
    private var placeholder: String

    init(label: String, text: Binding<String>, placeholder: String) {
        self._text = text
        self.label = label
        self.placeholder = placeholder
    }
    
    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField(placeholder, text: $text)
                .font(.body)
                .padding(.vertical, 18)
                .padding(.horizontal, 14)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

#Preview {
    TextFieldStringView(
        label: "Label",
        text: .constant(""),
        placeholder: "Placeholder"
    )
}
