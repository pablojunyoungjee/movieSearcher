//
//  MovieImage.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/11.
//

import Foundation

struct MovieImage {
    var title: String //"‘다크나이트 라이즈’ 베일 벗다"
    var link: String // "http://imgnews.naver.net/image/5089/2011/12/21/f5f4784cddca48108c0bfd35d97ab194_20111220010105.jpg"
    var thumbNail: String // "https://search.pstatic.net/common/?src=http://imgnews.naver.net/image/5089/2011/12/21/f5f4784cddca48108c0bfd35d97ab194_20111220010105.jpg&type=b150"
    var sizeWidth: String // "300"
    var sizeHeight: String // "388"
    
    init() {
        self.title = ""
        self.link = ""
        self.thumbNail = ""
        self.sizeWidth = ""
        self.sizeHeight = ""
    }
}

extension MovieImage: Decodable {
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case link = "link"
        case thumbNail = "thumbnail"
        case sizeWidth = "sizewidth"
        case sizeHeight = "sizeheight"
    }
    
    //TODO: DecodeIfPresent
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.link = try container.decodeIfPresent(String.self, forKey: .link) ?? ""
        self.thumbNail = try container.decodeIfPresent(String.self, forKey: .thumbNail) ?? ""
        self.sizeWidth = try container.decodeIfPresent(String.self, forKey: .sizeWidth) ?? ""
        self.sizeHeight = try container.decodeIfPresent(String.self, forKey: .sizeHeight) ?? ""
    }
}

extension MovieImage: Equatable {
    static func == (lhs: MovieImage, rhs: MovieImage) -> Bool {
        return lhs.link == rhs.link
    }
}
