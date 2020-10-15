//
//  JSONParsable.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/11.
//

import Foundation

protocol JSONParsable {
    func decode<T: Decodable>(data: Data) throws -> T
}

extension JSONParsable {
    
    func decode<T: Decodable>(data: Data) throws -> T {
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error {
            throw NSError(domain: "decode Error : \(error)", code: -1, userInfo: nil)
        }
    }
}



