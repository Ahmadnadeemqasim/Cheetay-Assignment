//
//  RequestConverter.swift
//  Assignment
//
//  Created by Ahmad Qasim  on 1/9/23.
//

import Foundation
import Alamofire

protocol RequestConvertible {
    var method: HTTPMethod {get set}
    var route: String {get set}
    var parameters: Parameters? {get set}
    var headers: RequestHeaders? { get set }
}

/// Converter object that will allow us to play nicely with Alamofire
struct RequestConverter: RequestConvertible {
    
    var method: HTTPMethod
    var route: String
    var parameters: Parameters?
    var headers: RequestHeaders?
    let encoding:Alamofire.ParameterEncoding?
    
    
    init(param:String? = nil,method:HTTPMethod,route:String,parameters:Parameters? = nil,headers:RequestHeaders? = [:],encoding:Alamofire.ParameterEncoding? = JSONEncoding.default) {
        
        self.method = method
        self.route = route
        self.parameters = ["api_key": C.requestHeaders.API_KEY ]// parameters
        self.encoding = encoding
        self.headers = getDefaultHeaders(headers:headers, timeStamp: nil)
    }
}

extension RequestConverter {
    
    func getDefaultHeaders(headers:RequestHeaders?,timeStamp:Double?) -> RequestHeaders {
        
        var requestHeaders: RequestHeaders = [:]
        requestHeaders["Content-Type"] = "application/x-www-form-urlencoded"
        
        
//        requestHeaders["Authorization"] = C.requestHeaders.API_KEY
        guard let headers = headers else { return requestHeaders }
        requestHeaders.merge(dict: headers)
        return requestHeaders
    }
    
}

extension RequestConverter : URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = try APIRouter.basePath.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(route))
        urlRequest.timeoutInterval = 60
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
//        if route.range(of: C.Endpoints.getPostCategories) != nil || route.range(of: "category/") != nil {
//            urlRequest.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
//        }
        let parameter = parameters
        if let _encoding = encoding {
            return try _encoding.encode(urlRequest, with: parameter)
        }
        return urlRequest
    }
}


