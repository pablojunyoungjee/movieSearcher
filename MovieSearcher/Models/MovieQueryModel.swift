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

    private let movieQueryListRelay: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    private let selectedQuerySubject: PublishSubject<String> = PublishSubject()
    private let toggleHiddenSubject: PublishSubject<Bool> = PublishSubject()
    
    init() {
        
    }
    
    // MARK: - Presentation Logic
    var movieQueryList: Observable<[String]> {
        return movieQueryListRelay.asObservable()
    }
    
    var selectedQueryObservable: Observable<String> {
        return selectedQuerySubject.asObservable()
    }
    
    var toggleHiddenObservable: Observable<Bool> {
        return toggleHiddenSubject.asObservable()
    }
    
    
    // MARK: - Interactor
    func addUserTextInput(input: String) {
        var searchedText = movieQueryListRelay.value
        if searchedText.count == 10 {
            searchedText.removeFirst()
        }
        
        searchedText.append(input)
        
        movieQueryListRelay.accept(searchedText)
    }
    
    func didUserSelectQuery(indexPathRow: Int) {
        let text = movieQueryListRelay.value[indexPathRow]
        selectedQuerySubject.on(.next(text))
    }
    
    func toggleQueryHidden(flag: Bool) {
        toggleHiddenSubject.on(.next(flag))
    }
    
}
