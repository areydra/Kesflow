//
//  NavigationViewModel.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/13/25.
//

import Foundation

@Observable class NavigationViewModel {
    var path: [ViewKeys] = []
    
    func push(_ path: ViewKeys) {
        self.path.append(path)
    }
}
