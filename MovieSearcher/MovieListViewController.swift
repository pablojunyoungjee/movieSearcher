//
//  MovieListViewController.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/10.
//

import UIKit

class MovieListViewController: UIViewController, Presentable {
    
    var viewModel: MovieListViewModel!
    
    //TODO: init with viewModelParam
//    init(viewModel: MovieListViewModel) {
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
//    }
    
    deinit {
        print("\(self) deinit called ")
    }
    
    override func loadView() {
        super.loadView()
        initViewHierarchy()
        setupLayout()
        setupStyling()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = MovieListViewModel()
        // Do any additional setup after loading the view.
    }
    
    func initViewHierarchy() {
        
    }
    
    func setupLayout() {
        
    }
    
    func setupStyling() {
        
    }
}

