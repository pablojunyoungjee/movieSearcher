//
//  MovieDataCellViewModel.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/15.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import RxDataSources


struct MovieDataCellViewModel {
    var title: String //"더 <b>배트맨</b>"
    var link: String? //https://movie.naver.com/movie/bi/mi/basic.nhn?code=154282
    var image: String //https://ssl.pstatic.net/imgmovie/mdi/mit110/1542/154282_P01_114951.jpg
    var subTitle: String //The Batman
    var pubDate: String //2021
    var director: String //맷 리브스|
    var actor: String //로버트 패틴슨|앤디 서키스|조 크라비츠|
    var userRating: String //"8.82"
    
    init(viewModel: MovieData) {
        self.title = viewModel.title
        self.link = nil
        self.image = viewModel.image
        
        let replacedSubtitle = viewModel.subTitle
            .replacingOccurrences(of: "<b>", with: "")
            .replacingOccurrences(of: "</b>", with: "")
        
        self.subTitle = replacedSubtitle
        self.pubDate = viewModel.pubDate
        
        let replacedDirector = viewModel.director
            .replacingOccurrences(of: "|", with: " ")
        
        self.director = replacedDirector
        
        let replacedActor = viewModel.actor
            .replacingOccurrences(of: "|", with: " ")
        
        self.actor = replacedActor
        self.userRating = viewModel.userRating
    }
    
}

