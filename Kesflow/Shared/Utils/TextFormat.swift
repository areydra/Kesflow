//
//  TextFormat.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/2/25.
//

import Foundation

// Function to format the text as IDR (1.000, 10.000, etc.)
func formatDecimalInThousand(text: String) -> String {
    guard let number = Double(unformatDecimal(text: text)) else { return text }

    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = "."
    formatter.maximumFractionDigits = 0
    
    return formatter.string(from: NSNumber(value: number)) ?? text
}

// Function to remove formatting (e.g., from 1.000 to 1000)
func unformatDecimal(text: String) -> String {
    return text.replacingOccurrences(of: ".", with: "")
}
