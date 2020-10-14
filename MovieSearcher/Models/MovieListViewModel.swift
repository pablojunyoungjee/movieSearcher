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
    private let movieDataListRelay: BehaviorRelay<[MovieData]> = BehaviorRelay(value: [])
    
    private let searchKeywordSubject: PublishSubject<String?> = PublishSubject()
    
    
    private var pageIndex: Int = 1
    
    private var recodedIndex: Int = 0
    
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
                self?.pageIndex = 1
                self?.loadMovieData(input: string, index: self?.pageIndex ?? 1, isLoadMore: false)
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
    
    private func loadMovieData(input: String?, index: Int, isLoadMore: Bool) {
        useCase.fetchMovieList(param: ["query": input ?? "", "start": index])
            .map({ [weak self] (result) -> [MovieData] in
                let previousValue = self?.movieDataListRelay.value ?? []
                let receivedValue = result
                if isLoadMore {
                    let appended = previousValue + receivedValue.movies
                    let nonDuplicated = appended.removeDuplicates()
                    return nonDuplicated
                } else {
                    return receivedValue.movies
                }
            })
            .subscribe { [weak self] (value) in
            self?.movieDataListRelay.accept(value)
        }.disposed(by: self.disposeBag)
    }
    
    // MARK: - Presentation Logic
    //TODO: AsDriver
    var movieDataListDataSource: Observable<[MovieData]> {
        return movieDataListRelay.asObservable()
    }
    //TODO: AsDriver
    //TODO: Move to UITableViewCell
    var movieImageListDataSource: Observable<[MovieImage]> {
        return movieImageListRelay.asObservable()
    }
    //TODO: AsDriver
    var movieQueryListDataSource: Observable<[MovieQuery]> {
        return movieQueryListRelay.asObservable()
    }

    // MARK: - Interactor
    func searchMovieWithUserInput(input: String?) {
        searchKeywordSubject.on(.next(input))
    }
    
    func loadMoreMovieData(index: Int, input: String?) {
        recodedIndex = index
        print("indexCheck : \(recodedIndex)")
        if recodedIndex == movieDataListRelay.value.count - 1 {
            pageIndex += 1
            loadMovieData(input: input, index: pageIndex, isLoadMore: true)
        }
        
    }
    
    
}
