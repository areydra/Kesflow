//
//  ProductServiceProviding.swift
//  Kesflow
//
//  Created by Areydra Desfikriandre on 4/14/25.
//

protocol ProductServiceProviding {
    func get() -> [ProductEntity]?
    func getSpecificByName(name: String?) -> ProductEntity?
}
