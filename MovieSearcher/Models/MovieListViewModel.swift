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

final class MovieListViewModel {
    //TODO: other private values, Subject, Observables stay here
    private let disposeBag = DisposeBag()
    private let useCase: MovieListUseCase
    private let movieQueryListRelay: BehaviorRelay<[MovieQuery]> = BehaviorRelay(value: [])
    private let movieDataListRelay: PublishSubject<[MovieData]> = PublishSubject()
    
    //TODO: Move to UITableViewCell
    private let movieImageListRelay: BehaviorRelay<[MovieImage]> = BehaviorRelay(value: [])
    
    //TODO: set usecase via init param
    init() {
        self.useCase = MovieListUseCase()
        load()
    }
    
    deinit {
        print("\(self) deinit called ")
    }
    
    func load() {
        let movieList = useCase.fetchMovieList()
        let imageList = useCase.fetchMovieImages()

        useCase.fetchMovieList().subscribe { [weak self] (result) in
            self?.movieDataListRelay.on(.next(result.movies))
        }.disposed(by: self.disposeBag)

        
        //TODO: Fix
//        Observable.combineLatest(movieList, imageList).subscribe { [weak self] (datas, images) in
//            print("movieList and imageList Onnext")
//            self?.movieDataListRelay.accept(datas.movies)
//            self?.movieImageListRelay.accept(images.images)
//            } onError: { error in
//                print("movieList and imageList Error")
//            } onCompleted: {
//                print("movieList and imageList onCompleted")
//            } onDisposed: {
//                print("movieList and imageList onDisposed")
//            }.disposed(by: self.disposeBag)
    }
    
    
    // output to view, vc
    // MARK: - Presentation Logic
    //TODO: AsDriver
    var movieDataListDataSource: Observable<[MovieData]> {
        return movieDataListRelay.asObservable()
    }
    //TODO: AsDriver
    var movieImageListDataSource: Observable<[MovieImage]> {
        return movieImageListRelay.asObservable()
    }
    //TODO: AsDriver
    var movieQueryListDataSource: Observable<[MovieQuery]> {
        return movieQueryListRelay.asObservable()
    }

    //input to vm
    // MARK: - Interactor
    
    
}
