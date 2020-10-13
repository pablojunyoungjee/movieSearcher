//
//  MovieData.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/11.
//

import Foundation

struct MovieData {
    var title: String //"더 <b>배트맨</b>"
    var link: String //https://movie.naver.com/movie/bi/mi/basic.nhn?code=154282
    var image: String //https://ssl.pstatic.net/imgmovie/mdi/mit110/1542/154282_P01_114951.jpg
    var subTitle: String //The Batman
    var pubDate: String //2021
    var director: String //맷 리브스|
    var actor: String //로버트 패틴슨|앤디 서키스|조 크라비츠|
    var userRating: String //"8.82"
    
    init() {
        self.title = ""
        self.link = ""
        self.image = ""
        self.subTitle = ""
        self.pubDate = ""
        self.director = ""
        self.actor = ""
        self.userRating = ""
    }
}

extension MovieData: Decodable {
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case link = "link"
        case image = "image"
        case subTitle = "subTitle"
        case pubDate = "pubDate"
        case director = "director"
        case actor = "actor"
        case userRating = "userRating"
    }
    
    //TODO: DecodeIfPresent
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try container.decode(String.self, forKey: .title)
        self.link = try container.decode(String.self, forKey: .link)
        self.image = try container.decode(String.self, forKey: .image)
        self.subTitle = try container.decode(String.self, forKey: .subTitle)
        self.pubDate = try container.decode(String.self, forKey: .pubDate)
        self.director = try container.decode(String.self, forKey: .director)
        self.actor = try container.decode(String.self, forKey: .actor)
        self.userRating = try container.decode(String.self, forKey: .userRating)
    }
}
