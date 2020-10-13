//
//  MovieImageSearchResult.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/13.
//

import Foundation

struct MovieImageSearchResult: Decodable {
    var images: [MovieImage]
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.images = try container.decode([MovieImage].self, forKey: .items)
    }
}
