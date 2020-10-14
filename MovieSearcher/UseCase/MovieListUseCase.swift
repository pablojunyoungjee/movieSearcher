//
//  MovieListUseCase.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/11.
//

import Foundation
import RxSwift

protocol MovieDataUseCase: JSONParsable {
    func fetchMovieList(param: [String:Any]?) -> Observable<MovieDataSearchResult>
}

protocol MovieImageUseCase: JSONParsable {
    func fetchMovieImages(param: [String:Any]?) -> Observable<MovieImageSearchResult>
}

class MovieListUseCase: MovieDataUseCase, MovieImageUseCase {
    deinit {
        print("\(self) deinit called ")
    }
}


extension MovieListUseCase {
    func fetchMovieList(param: [String:Any]?) -> Observable<MovieDataSearchResult> {
        //TODO: Check Decode
        let movieListAPI: HttpAPI
        movieListAPI = API.MovieData.movieList
        return movieListAPI.request(param: param).map { data in
            let value: MovieDataSearchResult = try self.decode(data: data)
            return value
        }
    }
    
    func fetchMovieImages(param: [String:Any]?) -> Observable<MovieImageSearchResult> {
        //TODO: Check Decode
        let movieImagesAPI: HttpAPI
        movieImagesAPI = API.MovieData.movieImage
        return movieImagesAPI.request(param: param).map { data in
            let value: MovieImageSearchResult = try self.decode(data: data)
            return value
        }
    }
}
