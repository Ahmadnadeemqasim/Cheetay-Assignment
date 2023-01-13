//
//  MovieService.swift
//  Assignment
//
//  Created by Ahmad Qasim  on 1/9/23.
//

import Foundation


struct MovieService {
    
    func getPopularMoviesList(request: MoviesApiRequest, completion:@escaping(Result<MoviesApiResponse>) -> Void){
        let router = APIRouter.popular.get( parameters: request.dictionary)
        OLAPIInterface.sharedInstance.request(router, decodingType: MoviesApiResponse.self, completion: completion)
    }
    func getSearchedMoviesList(request: SearchMovieByNameApiRequest, completion:@escaping(Result<MoviesApiResponse>) -> Void){
        let router = APIRouter.popular.get( parameters: request.dictionary)
        OLAPIInterface.sharedInstance.request(router, decodingType: MoviesApiResponse.self, completion: completion)
    }
}

