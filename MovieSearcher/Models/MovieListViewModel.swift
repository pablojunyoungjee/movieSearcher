//
//  MovieListViewModel.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/11.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class MovieListViewModel {
    //TODO: other private values, Subject, Observables stay here
    private let useCase: MovieListUseCase
    private let movieDataListRelay: BehaviorRelay<MovieData>
    private let movieImageListRelay: BehaviorRelay<MovieImage>
    
    //TODO: set usecase via init param
    init() {
        self.useCase = MovieListUseCase()
        load()
    }
    
    deinit {
        print("\(self) deinit called ")
    }
    
    func load() {
        //TODO: Combine Latest?
        useCase.fetchMovieList()
        useCase.fetchMovieImages()
    }
}

// output to view, vc
// MARK: - Presentation Logic


//input to vm
// MARK: - Interactor
