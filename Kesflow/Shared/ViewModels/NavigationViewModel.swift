//
//  NavigationViewModel.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 3/13/25.
//

import Foundation

@Observable class NavigationViewModel {
    var path: [NavigationKey] = []
    
    func push(_ path: NavigationKey) {
        self.path.append(path)
    }
}
