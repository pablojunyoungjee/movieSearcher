//
//  MovieListViewModel.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/11.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import RxDataSources

final class MovieListViewModel {
    
    private let disposeBag = DisposeBag()
    private let useCase: MovieListUseCase
    
    var movieQueryModel: MovieQueryModel
    
    private let movieDataListRelay: BehaviorRelay<[MovieData]> = BehaviorRelay(value: [])
    
    private let searchKeywordSubject: PublishSubject<String?> = PublishSubject()
    
    private let routeSubject: PublishSubject<Scene> = PublishSubject()
    
    private var pageIndex: Int = 1
    
    private var recodedIndex: Int = 0
    
    
    init() {
        self.useCase = MovieListUseCase()
        self.movieQueryModel = MovieQueryModel()
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
        
        movieQueryModel.selectedQueryObservable.subscribe(onNext: {[weak self] value in
            self?.pageIndex = 1
            self?.loadMovieData(input: value, index: self?.pageIndex ?? 1, isLoadMore: false)
            }).disposed(by: self.disposeBag)
    }
    
    private func loadMovieData(input: String?, index: Int, isLoadMore: Bool) {
        movieQueryModel.addUserTextInput(input: input ?? "")
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
    var movieDataListDataSource: Observable<[MovieData]> {
        return movieDataListRelay.asObservable()
    }
    
    var selectedQueryObservable: Observable<String> {
        return movieQueryModel.selectedQueryObservable
    }
    
    var routeObservable: Observable<Scene> {
        return routeSubject.asObservable()
    }

    // MARK: - Interactor
    func searchMovieWithUserInput(input: String?) {
        searchKeywordSubject.on(.next(input))
    }
    
    func loadMoreMovieData(index: Int, input: String?) {
        recodedIndex = index

        if recodedIndex == movieDataListRelay.value.count - 1 {
            pageIndex += 1
            loadMovieData(input: input, index: pageIndex, isLoadMore: true)
        }
    }
    
    func toggleQueryHidden(input: String?) {
        if let input = input
           ,input.count > 0 {
            movieQueryModel.toggleQueryHidden(flag: true)
        } else {
            movieQueryModel.toggleQueryHidden(flag: false)
        }
    }
    
    func didSelectMovie(indexPathRow: Int) {
        let selectedMovie = movieDataListRelay.value[indexPathRow].title
        let param = "\(selectedMovie), 영화"
        let dependency = MovieImageSceneDependency(param: param)
        routeSubject.on(.next(.movieImages(SceneContext(dependency: dependency))))
    }
}

struct MovieImageSceneDependency {
    let param: String
    
    init(param: String) {
        self.param = param
    }
}
