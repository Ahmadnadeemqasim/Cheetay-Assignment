//
//  APIRouter.swift
//  Assignment
//
//  Created by Ahmad Qasim  on 1/9/23.
//


import Foundation


struct APIRouter:URLRouter {
    
    static var basePath: String {
        return C.BaseURL.path
    }
    struct popular : Readable {
        var route: String = C.EndPoints.popular
    }
    struct search : Readable {
        var route: String = C.EndPoints.search
    }
}



