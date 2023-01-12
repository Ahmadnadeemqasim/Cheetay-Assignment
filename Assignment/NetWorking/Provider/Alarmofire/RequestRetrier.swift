//
//  RequestRetrier.swift
//  Assignment
//
//  Created by Ahmad Qasim  on 1/9/23.
//

import Foundation
import Alamofire

class RetryHandler: RequestRetrier {
    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: RequestRetryCompletion) {
        if let error = error as? URLError, error.code == .networkConnectionLost || error.code == .notConnectedToInternet {
            DispatchQueue.main.async {
                PaceProgressHUD.hideProgressHUDFromTop()
            }
            completion(true, 1.0) // retry after 1 second
        } else {
            completion(false, 0.0) // don't retry
        }
    }
}
