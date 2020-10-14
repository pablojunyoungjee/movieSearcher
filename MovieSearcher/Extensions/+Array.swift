//
//  +Array.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/15.
//

import Foundation

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}
