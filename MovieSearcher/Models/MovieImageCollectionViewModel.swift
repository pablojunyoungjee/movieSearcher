//
//  MovieImageCollectionViewModel.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/15.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import RxDataSources
import RxViewController

class MovieImageCollectionViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let useCase: MovieImageCollectionUseCase
    
    private let movieImageListRelay: BehaviorRelay<[MovieImage]> = BehaviorRelay(value: [])
    
    private let param: String
    
    private var pageIndex: Int = 1
    
    private var recodedIndex: Int = 0
    
    init(param: String) {
        self.useCase = MovieImageCollectionUseCase()
        self.param = param
        bind()
        loadMovieData(index: self.pageIndex, isLoadMore: false)
    }
    
    deinit {
        print("\(self) deinit called ")
    }
    
    func bind() {
        
    }
    
    func loadMovieData(index: Int, isLoadMore: Bool) {
        useCase.fetchMovieImages(param: ["query": param, "start": index])
            .map({ [weak self] (result) -> [MovieImage] in
                let previousValue = self?.movieImageListRelay.value ?? []
                let receivedValue = result.images
                if isLoadMore {
                    let appended = previousValue + receivedValue
                    let nonDuplicated = appended.removeDuplicates()
                    return nonDuplicated
                } else {
                    return receivedValue
                }
            })
            .subscribe { [weak self] (value) in
            self?.movieImageListRelay.accept(value)
        }.disposed(by: self.disposeBag)
    }
    
    // MARK: - Presentation Logic
    var movieImageListDataSource: BehaviorRelay<[MovieImage]> {
        return movieImageListRelay
    }
    
    // MARK: - Interactor
    
    func loadMoreMovieData(index: Int) {
        recodedIndex = index
        
        if recodedIndex == movieImageListRelay.value.count - 1 {
            pageIndex += 1
            loadMovieData(index: pageIndex, isLoadMore: true)
        }
    }
    
}
