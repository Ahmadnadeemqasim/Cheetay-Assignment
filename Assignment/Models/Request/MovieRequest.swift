//
//  MovieRequest.swift
//  Assignment
//
//  Created by Ahmad Qasim  on 1/12/23.
//

import Foundation

struct MoviesApiRequest: Codable {
    let page : Int = 1
    let apiKey : String = "e5ea3092880f4f3c25fbc537e9b37dc1"
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case apiKey = "api_key"
    }
}

struct SearchMovieByNameApiRequest: Codable {
    var movieName: String? = ""
    var page : Int = 1
    var apiKey : String = "e5ea3092880f4f3c25fbc537e9b37dc1"
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case movieName = "query"
        case apiKey = "api_key"
    }
}
