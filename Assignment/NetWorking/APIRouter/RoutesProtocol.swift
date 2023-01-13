//
//  APIRouter.swift
//  Assignment
//
//  Created by Ahmad Qasim  on 1/9/23.
//

import Alamofire

typealias RequestHeaders = [String: String]

struct CustomEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try! URLEncoding().encode(urlRequest, with: parameters)
        let urlString = request.url?.absoluteString.replacingOccurrences(of: "%3F", with: "?")
        request.url = URL(string: urlString!)
        return request
    }
}


protocol URLRouter {
    static var basePath: String { get }
    
}

protocol Routable {
    typealias Parameters = [String : Any] // whats its use ?
    var route: String {get set}
    init()
}

protocol Readable: Routable {}

protocol Creatable: Routable {}

protocol Updatable: Routable {}

protocol Deletable: Routable {}

protocol Patchable: Routable {}


extension Routable {
    
    /// Create instance of Object that conforms to Routable
    init() {
        self.init()
    }
}

extension Readable where Self: Routable {
    // FIXME : if rout path has appended paarams then provide a parameter in get, create etc to initialize it with that route else default
    static func get(editedPath:String? = nil,param:String? = nil,parameters: Parameters? = nil,headers: RequestHeaders? = nil) -> RequestConverter {
        
        let router = Self.init()
        
        var routePath = router.route
        
        if let param = param {
            routePath = "\(router.route)/\(param)"
        }
        
        if let path = editedPath {
            routePath = path
        }
        
        return RequestConverter(method: .get,
                                route: routePath,
                                parameters: parameters,
                                headers: headers,
                                encoding: CustomEncoding())
    }
    
    static func getQueryParams(editedPath:String? = nil,queryParams:Parameters? = nil,parameters: [String:String]? = nil,headers: RequestHeaders? = nil) -> RequestConverter {
        
        let router = Self.init()
        var routePath = router.route

        if let path = editedPath {
            routePath = path
        }
        // Custom encoding is given becasue edited path includes ? which in turn converts to %3F which do not works in request
        return RequestConverter(method: .get,
                                route: routePath,
                                parameters: parameters,
                                headers: headers,
                                encoding: CustomEncoding.init())
    }
}

extension Creatable where Self: Routable {
    
    static func create(parameters: Parameters? = nil, headers: RequestHeaders? = nil) -> RequestConverter {
        let router = Self.init()
        return RequestConverter(method: .post,
                                route: router.route,
                                parameters: parameters,
                                headers: headers,
                                encoding: CustomEncoding())
    }
}

extension Updatable where Self: Routable {
    
    static func update(editedPath:String? = nil, parameters: Parameters? = nil, headers: RequestHeaders? = nil) -> RequestConverter {
         let router = Self.init()
        var newPath = router.route
        if let path = editedPath {
            newPath = path
        }
        return RequestConverter(method: .put,
                                route: newPath,
                                parameters: parameters,
                                headers: headers,
                                encoding: CustomEncoding())
    }
}

extension Patchable where Self: Routable {
    
    static func update(editedPath:String? = nil,parameters: Parameters? = nil, headers: RequestHeaders? = nil) -> RequestConverter {
        let router = Self.init()
        var newPath = router.route
        if let path = editedPath {
            newPath = path
        }
        
        return RequestConverter(method: .patch,
                                route: newPath,
                                parameters: parameters,
                                headers: headers,
                                encoding: CustomEncoding())
    }
}

extension Deletable where Self: Routable {
    
    static func delete(parameters: Parameters? = nil, headers: RequestHeaders? = nil) -> RequestConverter {
        let router = Self.init()
        return RequestConverter(method: .delete,
                                route: router.route,
                                parameters: parameters,
                                headers: headers,
                                encoding:CustomEncoding())
    }
}


