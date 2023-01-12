//
//  APIResponse.swift
//  Hawi
//
//  Created by Codesk Studio Macmini on 12/07/2021.
//  Copyright © 2021 Mac Book Pro. All rights reserved.
//

import Foundation

struct APIResponse:Decodable {
    let error: String?
    let success : SucessResponse?
    let message : String?
    
    private enum CodingKeys:String,CodingKey {
        case error
        case success = "SUCCESS"
        case message
    }
    
}

struct SucessResponse:Decodable {
    var error:String?
    var status : String?
    var message : String?
    
    
    private enum CodingKeys:String,CodingKey {
        case error
        case status
        case message
    }
}
