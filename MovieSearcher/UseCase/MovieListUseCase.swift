//
//  MovieListUseCase.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/11.
//

import Foundation
import RxSwift

protocol MovieDataUseCase: JSONParsable {
    func fetchMovieList()
}

protocol MovieImageUseCase: JSONParsable {
    func fetchMovieImages()
}

class MovieListUseCase: MovieDataUseCase, MovieImageUseCase {
    //TODO: Deinit in struct?
    deinit {
        print("\(self) deinit called ")
    }
}


extension MovieListUseCase {
    func fetchMovieList() {
        //TODO: API Call
        let movieListAPI: HttpAPI
        movieListAPI = API.MovieData.movieList
        movieListAPI.request().map { data in
//            let value: model = try self.decode(data: data)
//            return value
        }
    }
    
    func fetchMovieImages() {
        //TODO: API Call
        let movieImagesAPI: HttpAPI
        movieImagesAPI = API.MovieData.movieImage
        movieImagesAPI.request().map { data in
//            let value: model = try self.decode(data: data)
//            return value
        }
    }
}
