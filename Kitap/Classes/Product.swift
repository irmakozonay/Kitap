//
//  Product.swift
//  Kitap
//
//  Created by Irmak Ozonay on 16.03.2021.
//

import Foundation

struct Product: Decodable { //todo adi cok common
    let category: String
    let name: String
    let models: [Model]
    
    struct Model: Decodable {
        let status: String
        let name: String
        let file: File
        
        struct File: Decodable {
            let ext: String
            let url: String
        }
    }
}
