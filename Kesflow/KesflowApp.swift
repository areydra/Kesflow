//
//  KesflowApp.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 2/28/25.
//

import SwiftUI

@main
struct KesflowApp: App {
    @State private var productsViewModel = ProductsViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(productsViewModel)
        
    }
}
