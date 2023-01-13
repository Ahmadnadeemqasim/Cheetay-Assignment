//
//  Constant.swift
//  Assignment
//
//  Created by Ahmad Qasim  on 1/9/23.
//

import Foundation

struct C{
    struct BaseURL {
        static let path = "https://api.themoviedb.org/3/"
        static let serverURL = "https://api.themoviedb.org/3/"
        static let imagPathURL = "https://image.tmdb.org/t/p/w92/"
    }
    struct requestHeaders {
        static let API_HOST  =  "api.themoviedb.org/3/"
        static let API_KEY  =  "e5ea3092880f4f3c25fbc537e9b37dc1"
    }
    struct EndPoints {
        static let popular  =   "movie/popular"
        static let search   =   "search/movie"
    }
}

extension Notification.Name {
    
    static let sessionOut = Notification.Name("sessionOut")
    static let internalServerError = Notification.Name("internalServerError")
    static let inAppAlert = Notification.Name("inAppAlert")
    static let pageNotfound = Notification.Name("pageNotfound")
    static let apiError = Notification.Name("apiError")
    static let serverNotfound = Notification.Name("serverNotfound")
    static let requestTimeOut = Notification.Name("requestTimeOut")
    }
