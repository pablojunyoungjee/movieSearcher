//
//  JSONParsable.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/11.
//

import Foundation
//TODO: FlatMapDecodable, requestAndDecode
protocol JSONParsable {
    func decode<T: Decodable>(data: Data) throws -> T
}

extension JSONParsable {
    //에러처리가 이 안에서 되는 것이 더 나은 구조일 듯..."파싱에러에 대해서는..."
    func decode<T: Decodable>(data: Data) throws -> T {
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error {
            throw NSError(domain: "decode Error : \(error)", code: -1, userInfo: nil)
        }
    }
}



