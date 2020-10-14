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
    
    private let searchKeywordSubject: PublishSubject<String?> = PublishSubject()
    private var pageIndex: Int = 1
    
    //TODO: Move to UITableViewCell
    private let movieImageListRelay: BehaviorRelay<[MovieImage]> = BehaviorRelay(value: [])
    
    //TODO: set usecase via init param
    init() {
        self.useCase = MovieListUseCase()
        bind()
    }
    
    deinit {
        print("\(self) deinit called ")
    }
    
    func bind() {
        searchKeywordSubject.subscribe(onNext: { [weak self] string in
            self?.loadMovieData(input: string, index: self?.pageIndex ?? 1)
            }).disposed(by: self.disposeBag)
        
        
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
    
    private func loadMovieData(input: String?, index: Int) {
        useCase.fetchMovieList(param: ["query": input ?? "", "start": index]).subscribe { [weak self] (result) in
            self?.movieDataListRelay.on(.next(result.movies))
        }.disposed(by: self.disposeBag)
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
    func searchMovieWithUserInput(input: String?) {
        //TODO: Throttle
        searchKeywordSubject.on(.next(input))
    }
    
    func increasePageIndex() {
        pageIndex += 1
        print("pageIndex : \(pageIndex)")
    }
    
    
}
