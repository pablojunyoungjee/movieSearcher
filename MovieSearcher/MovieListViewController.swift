//
//  MovieListViewController.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/10.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import RxDataSources
import RxViewController

class MovieListViewController: UIViewController, Presentable {
    
    private let disposeBag = DisposeBag()
    let listView: UITableView = UITableView()

    var viewModel: MovieListViewModel = MovieListViewModel()
    
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
        setupLayout()
        setupStyling()
        bind(viewModel: self.viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    func setupLayout() {
        var constraints: [NSLayoutConstraint] = []
        listView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(listView)
        constraints += [listView.topAnchor.constraint(equalTo: self.view.topAnchor),
                        listView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                        listView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                        listView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupStyling() {
        listView.separatorStyle = .none
        listView.estimatedRowHeight = 600
        listView.rowHeight = UITableView.automaticDimension
        listView.register(MovieDataCell.self, forCellReuseIdentifier: "MovieDataCell")
    }
    
    func bind(viewModel: MovieListViewModel) {
        self.rx.viewWillLayoutSubviews.take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.tableViewBind()
            }).disposed(by: self.disposeBag)
    }
    
    func tableViewBind() {
        self.viewModel.movieDataListDataSource.bind(to: self.listView.rx.items) {
            (tableView: UITableView, index: Int, element: MovieData) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDataCell") as? MovieDataCell else { return UITableViewCell() }
            cell.configure(cellData: element)
            return cell
        }.disposed(by: self.disposeBag)
    }
}
