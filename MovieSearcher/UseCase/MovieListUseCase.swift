//
//  MovieListUseCase.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/11.
//

import Foundation
import RxSwift

protocol MovieDataUseCase: JSONParsable {
    func fetchMovieList() -> Observable<[MovieData]>
}

protocol MovieImageUseCase: JSONParsable {
    func fetchMovieImages() -> Observable<[MovieImage]>
}

class MovieListUseCase: MovieDataUseCase, MovieImageUseCase {
    deinit {
        print("\(self) deinit called ")
    }
}


extension MovieListUseCase {
    func fetchMovieList() -> Observable<[MovieData]> {
        //TODO: Check Decode
        let movieListAPI: HttpAPI
        movieListAPI = API.MovieData.movieList
        return movieListAPI.request().map { data in
            let value: [MovieData] = try self.decode(data: data)
            return value
        }
    }
    
    func fetchMovieImages() -> Observable<[MovieImage]> {
        //TODO: Check Decode
        let movieImagesAPI: HttpAPI
        movieImagesAPI = API.MovieData.movieImage
        return movieImagesAPI.request().map { data in
            let value: [MovieImage] = try self.decode(data: data)
            return value
        }
    }
}
