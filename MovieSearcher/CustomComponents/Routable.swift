//
//  Routable.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/11.
//

import Foundation
import UIKit

//todo: : class ...넣어야 하나...
protocol Routable {
    func route(to scene: Scene)
}

//todo: indirect enum ...indirect는 재귀를 위해서 써야 할 듯 한데 지금 상황에서 넣어야 하나...
enum Scene {
    case movieImages
}

//scene이 될 vc에 넣어줘야 하는 디펜던시...즉 struct나 class 들
class SceneContext<Dependency> {
    let dependency: Dependency
    init(dependency: Dependency) {
        self.dependency = dependency
    }
}

//Scene을 만들 수 있는 객체가 따라야 하는 프로토콜
protocol SceneBuildable {
    
}

//Scene이 될 수 있는 객체가 따라야 하는 프로토콜
protocol Sceneable {
    
}
