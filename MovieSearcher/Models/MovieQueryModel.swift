//
//  MovieQuery.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/13.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import RxDataSources

struct MovieQueryModel {

    private let disposeBag = DisposeBag()
    private var searchedText: [String]
    private let selectedQuerySubject: PublishSubject<String> = PublishSubject()
    
    init() {
        self.searchedText = []
    }
    
    // MARK: - Presentation Logic
    var movieQueryList: Observable<[String]> {
        Observable.create { emitter in
            emitter.onNext(searchedText)
            return Disposables.create()
        }
    }
    
    var selectedQueryObservable: Observable<String> {
        return selectedQuerySubject.asObservable()
    }
    
    
    // MARK: - Interactor
    mutating func addUserTextInput(input: String) {
        searchedText.append(input)
    }
    
    func didUserSelectQuery(indexPathRow: Int) {
        let text = searchedText[indexPathRow]
        selectedQuerySubject.on(.next(text))
    }
    
}
