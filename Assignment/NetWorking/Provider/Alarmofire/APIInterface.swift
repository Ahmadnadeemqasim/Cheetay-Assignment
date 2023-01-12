//
//  APIIInterface.swift
//  Assignment
//
//  Created by Ahmad Qasim  on 1/9/23.
//

import Foundation


import Alamofire

typealias CompletionSuccessHandler = (_ decodeable:Decodable?)->Void
typealias CompletionErrorHandler = (_ error:Error?)->Void
typealias CompletionHandler<T,E: Error> = (Result<T>) -> Void

enum Result<T> {
    case success(T?)
    case failure(NetworkFailureReason)
}

class OLAPIInterface: NSObject {
    
    static private let manager = SessionManager.default
    
    static let sharedInstance = OLAPIInterface()
    
    override init() {
        super.init()
//        OLAPIInterface.manager.retrier = RetryHandler()
    }
    
    func request<T:Decodable>(_ request: RequestConvertible,decodingType:T.Type?,completion:@escaping (Result<T>) -> Void) {
        
        guard let requestConvertible = request as? URLRequestConvertible else {
            completion(Result.failure(.invalidRequestConvertable))
            return
        }

        OLAPIInterface.manager.request(requestConvertible).validate().responseJSON { [unowned self] (response) in
            self.translateObject(request, decodingType: decodingType, response: response, completion: completion)
            
        }
    }
    
    func upload<T:Decodable>(_ request: RequestConvertible,imageData:[Data]? = [],imageParam:String? = nil,imageName:String? = nil,decodingType:T.Type?,completion:@escaping (Result<T>) -> Void) {
        
        guard let requestConvertible = request as? URLRequestConvertible else {
            completion(Result.failure(.invalidRequestConvertable))
            return
        }
        
        OLAPIInterface.manager.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in request.parameters ?? [:] {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let imageData = imageData {
                for data in imageData {
                    
                    if imageData.count > 1 {
                        if let imageParam = imageParam , let imageName = imageName {
                            multipartFormData.append(data, withName: "\(imageParam)[]", fileName: imageName, mimeType: "image/jpeg")
                        }
                    } else {
                        if let imageParam = imageParam , let imageName = imageName {
                            multipartFormData.append(data, withName: imageParam, fileName: imageName, mimeType: "image/jpeg")
                        }
                    }
                    
                    
                }
            }
        }, with: requestConvertible) { (encodingResult) in
            switch encodingResult {
                
            case .success(let uploadRequest, _, _):
                
                uploadRequest.validate().responseJSON(completionHandler: {[unowned self] (successResponse) in
                    self.translateObject(request, decodingType: decodingType, response: successResponse, completion: completion)
                })
                break
            case .failure(let error):
                completion(Result.failure(NetworkFailureReason.responseFailed(error: error)))
                break
            }
        }
    }
    
    func uploadMultiple<T:Decodable>(_ request: RequestConvertible,
                                     imageData:[Data]? = [],
                                     imageParams:[String]? = nil,
                                     imageNames:[String]? = nil,
                                     decodingType:T.Type?,
                                     completion:@escaping (Result<T>) -> Void) {
        
        
        guard let requestConvertible = request as? URLRequestConvertible else {
            completion(Result.failure(.invalidRequestConvertable))
            return
        }
        
        
        OLAPIInterface.manager.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in request.parameters ?? [:] {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let imageData = imageData,
                let imageParam = imageParams,
                let imageNames = imageNames    {
                if imageData.count > 0 {
                    for i in 0...imageData.count - 1 {
                        let data = imageData[i]
                        let param = imageParam[i]
                        let imageName = imageNames[i] // Crash
                        
                        multipartFormData.append(data, withName: param, fileName: imageName, mimeType: "image/jpg")
                    }
                }
            }
        }, with: requestConvertible) { (encodingResult) in
            switch encodingResult {
                
            case .success(let uploadRequest, _, _):
                
                uploadRequest.validate().responseJSON(completionHandler: {[unowned self] (successResponse) in
                    self.translateObject(request, decodingType: decodingType, response: successResponse, completion: completion)
                })
                break
            case .failure(let error):
                completion(Result.failure(NetworkFailureReason.responseFailed(error: error)))
                break
            }
        }
    }
    
    private func translateObject<T:Decodable>(_ request: RequestConvertible,decodingType:T.Type?,response: DataResponse<Any>,completion:@escaping (Result<T>) -> Void) {
        
        print(response)
        print(response.response?.statusCode ?? 0)
        
        if response.result.error?._code == NSURLErrorTimedOut {
            NotificationCenter.default.post(name: .requestTimeOut, object: self, userInfo: nil)
            return
        }
        
        guard let _ = response.response else {
            NotificationCenter.default.post(name: .serverNotfound, object: self, userInfo: nil)
            return
        }
        
        
        
        switch response.result {
        case .success(let r):
            if let responseDict = r as? [String:AnyObject] {
                if let status = responseDict["status"] as? Bool, status == false {
                    let message = responseDict["message"] as? String ?? "An error occured. Please try again later."
                    completion(Result.failure(.reason(error: message)))
                    return
                }
                if let data = responseDict["data"] as? String, data == "" {
                    let message = responseDict["msg"] as? String ?? "An error occured. Please try again later."
                    completion(Result.failure(.reason(error: message)))
                    return
                }
            }
            do {
                guard let _ = decodingType else {return completion(Result.success(nil)) }
                
                guard let decodingType = decodingType,let data = response.data  else { return completion(Result.failure(.decodingTypeFailed))}
                if data == Data() { // To Check if data is of zero Bytes
                    completion(.success(nil))
                    return
                }
                
                let decodeableObj = try JSONDecoder().decode(decodingType, from: data)
                completion(.success(decodeableObj))
            } catch let error {
                print(error)
                completion(Result.failure(NetworkFailureReason.decodingFailed(error: error)))
            }
            break
        case .failure(_) where response.response?.statusCode == 404 : // for page not found
            NotificationCenter.default.post(name: .pageNotfound, object: self, userInfo: nil)
            break
        case .failure(_) where response.response?.statusCode == 403 : // for session out
            NotificationCenter.default.post(name: .sessionOut, object: self, userInfo: nil)
            break
        case .failure(let error) where response.response?.statusCode == 401 : // for HawkAuthentication issue/Unautharized error
            NotificationCenter.default.post(name: .sessionOut, object: self, userInfo: nil)
//            completion(Result.failure(NetworkFailureReason.responseFailed(error: error)))
            break
        case .failure( _) where (response.response?.statusCode ?? 0 >= 500 && response.response?.statusCode ?? 0 <= 600): // for internal server error
            var userInfo : [String:Any]?
            if let response_ = response.response, let requestId =  response_.allHeaderFields["x-request-id"]   {
                userInfo = ["requestId":requestId]
            }
            NotificationCenter.default.post(name: .apiError, object: self, userInfo: userInfo)
            break
        case .failure(_) where response.response?.statusCode == 422:
            do {
                guard let _ = decodingType else {return completion(Result.failure(NetworkFailureReason.invalidRequestConvertable)) }
                
                let decodeableObj = try JSONDecoder().decode(APIResponse.self, from: response.data!)
                //completion(.success(decodeableObj))
                completion(.failure(NetworkFailureReason.apiResponse(response: decodeableObj))) // For API errors e.g : Invalid Username and password comes with code 422
            } catch (let error) {
                completion(Result.failure(NetworkFailureReason.decodingFailed(error: error)))
            }
            
            break
        case .failure(let error):
            completion(Result.failure(NetworkFailureReason.responseFailed(error: error)))
            break
        }
    }
//    
//    private func getTimeChangedRequestHeaders(_ request: RequestConvertible,response:HTTPURLResponse) -> RequestHeaders? {
//        //["Hawk ts=\"1550150379\"", " tsm=\"nIcPNVxB0CkAIrR9Nluj7WydQcz/O8H5MhMQ70CRrL8=\"", " error=\"Stale ts\""]
//        let serverResponse = response.allHeaderFields["server-authorization"]
//        guard let serverAuth = serverResponse as? String else {return nil}
//        let components2 = serverAuth.split(separator: ",")
//        //["Hawk ts=\"1550150539\"", " tsm=\"Be9lenknSINVjPg/uHauwt1DLSo6Pc2ZMmdB4u7UBNo=\"", " error=\"Stale ts\""]
//        let arr2 = components2.filter { item in
//            return item.lowercased().contains("ts")
//        }
//        if arr2.count > 0 {
//            //- 0 : "Hawk" //- 1 : "ts=\"1550150539\""
//            let arr3 = arr2.first?.components(separatedBy: " ")
//            if let arr3 = arr3 {
//                let serverTS = arr3.last
//                let newTS = serverTS?.components(separatedBy: "=").last?.components(separatedBy: "\"")[1] as! String
//                let requestConverter = (request as! RequestConverter)
//                
//                let newHeaders =  requestConverter.getDefaultHeaders(headers: requestConverter.headers, timeStamp: Double(newTS))
//                return newHeaders
//            }
//            return nil
//        }
//        
//        return nil
//    }
    
}

