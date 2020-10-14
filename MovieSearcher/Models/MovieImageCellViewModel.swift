//
//  MovieImageCellViewModel.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/15.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import RxDataSources

struct MovieImageCellViewModel {
    var title: String //"‘다크나이트 라이즈’ 베일 벗다"
    var link: String // "http://imgnews.naver.net/image/5089/2011/12/21/f5f4784cddca48108c0bfd35d97ab194_20111220010105.jpg"
    var thumbNail: String // "https://search.pstatic.net/common/?src=http://imgnews.naver.net/image/5089/2011/12/21/f5f4784cddca48108c0bfd35d97ab194_20111220010105.jpg&type=b150"
    var sizeWidth: String // "300"
    var sizeHeight: String // "388"
    
    init(viewModel: MovieImage) {
        self.title = viewModel.title
        self.link = viewModel.link
        self.thumbNail = viewModel.thumbNail
        self.sizeWidth = viewModel.sizeWidth
        self.sizeHeight = viewModel.sizeHeight
    }
}
