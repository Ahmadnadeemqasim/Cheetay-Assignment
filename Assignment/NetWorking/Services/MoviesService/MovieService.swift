//
//  MovieService.swift
//  Assignment
//
//  Created by Ahmad Qasim  on 1/9/23.
//

import Foundation


struct MovieService {
    
//    func login (request: LoginRequest, completion:@escaping(Result<UserResponse>) -> Void) {
//        let router = APIRouter.login.create(parameters: request.dictionary)
//        OLAPIInterface.sharedInstance.request(router, decodingType: UserResponse.self, completion: completion)
//    }
    func getPopularMoviesList(completion:@escaping(Result<MoviesApiResponse>) -> Void){
//        let router = APIRouter.recipeList.create(parameters: request.dictionary)
        let router = APIRouter.popular.get()
        OLAPIInterface.sharedInstance.request(router, decodingType: MoviesApiResponse.self, completion: completion)
    }
//    func updateProfilePic (request:SignUpRequest,imageData: [Data]?,imageParams:[String]?, imageNames: [String]?, completion:@escaping (Result<UserResponse>) -> Void) {
//
//        var headers = ["Content-type": "multipart/form-data"]
//        var token : String = ""
//        if let jwt = UserDefaultsService.shared.savedJWT() {
//            token = "Bearer " + jwt
//        }
//        headers["Authorization"] = token
//
//        //        var router = APIRouter.userSignup.create()
//        var router = APIRouter.userSignup.create(parameters: request.dictionary)
//        router.headers = headers
//
//        OLAPIInterface.sharedInstance.uploadMultiple(router,
//                                                     imageData: imageData,
//                                                     imageParams:  imageParams,
//                                                     imageNames: imageNames,
//                                                     decodingType: UserResponse.self,
//                                                     completion: completion)
//
//    }
}

