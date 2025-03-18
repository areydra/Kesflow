//
//  TextEditorView.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/14/25.
//

import SwiftUI

struct TextEditorView: View {
    @Binding private var text: String
    private var label: String
    private var height: CGFloat

    init(label: String, text: Binding<String>, height: CGFloat = 200) {
        self._text = text
        self.label = label
        self.height = height
    }
    
    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextEditor(text: $text)
                .padding(.vertical, 10)
                .padding(.horizontal, 8)
                .frame(height: height)
                .overlay {
                    RoundedRectangle(cornerRadius: 14)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundStyle(Color.gray.opacity(0.2))
                        .allowsHitTesting(false)
                }
        }
    }
}

#Preview {
    TextEditorView(
        label: "Label",
        text: .constant("")
    )
}
