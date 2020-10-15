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

class MovieListViewController: UIViewController, Presentable, MovieListSceneRoutable {
    
    private let disposeBag = DisposeBag()
    private let listView: UITableView = UITableView()
    private let searchBar: UISearchBar = UISearchBar()
    private var movieQueryView: MovieQueryView!

    var viewModel: MovieListViewModel = MovieListViewModel()

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
        self.movieQueryView = MovieQueryView(viewModel: self.viewModel.movieQueryModel)
        
        var constraints: [NSLayoutConstraint] = []
        listView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        movieQueryView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(listView)
        self.view.addSubview(searchBar)
        self.view.addSubview(movieQueryView)
        constraints += [listView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
                        listView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                        listView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                        listView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                        searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                        searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                        searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                        movieQueryView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
                        movieQueryView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                        movieQueryView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                        movieQueryView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
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
        
        self.rx.viewDidLoad.take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.movieQueryView.isHidden = true
            }).disposed(by: self.disposeBag)
        
        self.rx.viewWillLayoutSubviews.take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.tableViewBind()
            }).disposed(by: self.disposeBag)
        
        
        let searchBarTextObservable = self.searchBar.rx.text.throttle(.milliseconds(700), scheduler: MainScheduler.instance)
        let searchBarDidBeginEditingObservable = self.searchBar.rx.textDidBeginEditing
        
        Observable.combineLatest(searchBarTextObservable, searchBarDidBeginEditingObservable)
            .subscribe(onNext: { [weak self] string, _ in
                self?.viewModel.toggleQueryHidden(input: string)
            }).disposed(by: self.disposeBag)
        
        self.searchBar.rx.text.skip(1)
            .throttle(.milliseconds(1700), scheduler: MainScheduler.instance)
            .subscribe(onNext: { string in
                viewModel.searchMovieWithUserInput(input: string)
            }).disposed(by: self.disposeBag)
        
        self.viewModel.selectedQueryObservable.subscribe(onNext: { [weak self] string in
                self?.searchBar.text = string
            }).disposed(by: self.disposeBag)
        
        self.viewModel.routeObservable.subscribe(onNext: { [weak self] scene in
            self?.route(to: scene)
            }).disposed(by: self.disposeBag)
    }
    
    func tableViewBind() {
        self.viewModel.movieDataListDataSource.bind(to: self.listView.rx.items) {
            (tableView: UITableView, index: Int, element: MovieData) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDataCell") as? MovieDataCell else { return UITableViewCell() }
            let cellViewModel = MovieDataCellViewModel(viewModel: element)
            cell.configure(cellData: cellViewModel)
            return cell
        }.disposed(by: self.disposeBag)
        
        self.listView.rx.willDisplayCell.subscribe(onNext: {
            [weak self] event in
            self?.viewModel.loadMoreMovieData(index: event.indexPath.row, input: self?.searchBar.text)
        }).disposed(by: self.disposeBag)
        
        self.listView.rx.itemSelected.subscribe(onNext: { [weak self] event in
            self?.viewModel.didSelectMovie(indexPathRow: event.item)
        }).disposed(by: self.disposeBag)
    }
}
