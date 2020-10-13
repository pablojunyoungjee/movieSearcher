//
//  MovieDataSearchResult.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/13.
//

import Foundation

struct MovieDataSearchResult {
    
    var movies: [MovieData]
    var total: Int
    var start: Int
    
    init() {
        self.movies = []
        self.total = 0
        self.start = 0 //
    }
    
}

extension MovieDataSearchResult: Decodable {
    enum CodingKeys: String, CodingKey {
        case items = "items"
        case total = "total"
        case start = "start"
    }
    
    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.movies = try container.decode([MovieData].self, forKey: .items)
        self.total = try container.decode(Int.self, forKey: .total)
        self.start = try container.decode(Int.self, forKey: .start)
    }
}
