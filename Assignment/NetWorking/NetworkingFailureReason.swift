//
//  NetworkFailureReason.swift
//  Assignment
//
//  Created by Ahmad Qasim  on 1/9/23.
//

import Foundation

import Alamofire
enum NetworkFailureReason {
    case decodingTypeFailed
    case decodingFailed(error: Error)
    case invalidRequestConvertable
    case responseFailed(error: Error)
    case apiResponse(response:APIResponse)
    case sessionOut
    case internalServerError
    case other
    case reason(error:String)
    case hawkServerTimeIssue
}

extension NetworkFailureReason: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .decodingTypeFailed: return "Decoding Type issue"
        case .decodingFailed(let error): return error.localizedDescription
        case .invalidRequestConvertable: return "Request is not valid."
        case .responseFailed(let error):
            if error.localizedDescription.contains("Response could not be serialized") {
                return "logged_out".localize
            }
            return error.localizedDescription
        case .apiResponse(let response): return response.error ?? response.success?.error ?? ""
        case .sessionOut: return "logged_out".localize
        case .internalServerError: return "e50x".localize
        case .reason(let error): return error.localize
        case .hawkServerTimeIssue: return "Server time not matches with Device time"
        case .other: return "Something went wrong."
        }
    }
}
