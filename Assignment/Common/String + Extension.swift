//
//  String + Extension.swift
//  Assignment
//
//  Created by Devin Ellis  on 1/9/23.
//

import Foundation

extension String {
    
    var localize : String {
        get {
           return NSLocalizedString(self, comment: "")
        }
        set (key) {
            
        }
    }
}
