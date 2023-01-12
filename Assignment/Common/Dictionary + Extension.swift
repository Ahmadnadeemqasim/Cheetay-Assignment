//
//  Dictionary + Extension.swift
//  Assignment
//
//  Created by Ahmad Qasim  on 1/9/23.
//

import Foundation
extension Dictionary { // To merger headers above
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
