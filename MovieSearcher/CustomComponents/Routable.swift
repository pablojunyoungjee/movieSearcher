//
//  Routable.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/15.
//

import Foundation
import UIKit

protocol Routable: class {
    func route(to scene: Scene)
}

enum Scene {
    case movieImages(SceneContext<MovieImageSceneDependency>)
    case anotherDummyScene
}

class SceneContext<Dependency> {
    let dependency: Dependency
    init(dependency: Dependency) {
        self.dependency = dependency
    }
}

protocol SceneBuildable {
    
}

protocol Scenable {
    
}

protocol MovieListSceneRoutable: Routable, MovieImageCollectionViewSceneBuildable {

}

extension MovieListSceneRoutable where Self: UIViewController {
    func route(to scene: Scene) {
        switch scene {
        case let .movieImages(context):
            guard let scene = buildMovieImageCollectionViewScene(context: context) as? UIViewController else { return }
            self.present(scene, animated: true, completion: nil)
        default:
            break
        }
    }
}

protocol MovieImageCollectionViewSceneBuildable: SceneBuildable {
    
}

extension MovieImageCollectionViewSceneBuildable {
    func buildMovieImageCollectionViewScene(context: SceneContext<MovieImageSceneDependency>) -> Scenable {
        let viewModel = MovieImageCollectionViewModel(param: context.dependency.param)
        let vc = MovieImageCollectionViewController(viewModel: viewModel)
        return vc
    }
}
