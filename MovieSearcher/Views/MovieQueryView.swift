//
//  MovieQueryView.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/15.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import RxDataSources

class MovieQueryView: UIView, Presentable {
    
    private let disposeBag = DisposeBag()
    private let listView: UITableView = UITableView()
    private var viewModel: MovieQueryModel!
    
    convenience init(viewModel: MovieQueryModel) {
        self.init()
        self.viewModel = viewModel
        setupLayout()
        setupStyling()
        bind()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        listView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(listView)
        
        var constraint: [NSLayoutConstraint] = []
        constraint += [listView.topAnchor.constraint(equalTo: self.topAnchor),
                       listView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                       listView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                       listView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraint)
    }
    
    func setupStyling() {
        listView.separatorStyle = .none
        listView.register(MovieQueryCell.self, forCellReuseIdentifier: "MovieQueryCell")
        listView.rowHeight = 50
    }
    
    func bind() {
        tableViewBind()
        
        viewModel.toggleHiddenObservable.subscribe(onNext: { [weak self] value in
            self?.isHidden = value
        }).disposed(by: self.disposeBag)
    }
    
    func tableViewBind() {
        self.viewModel.movieQueryList.bind(to: self.listView.rx.items) {
            (tableView: UITableView, index: Int, element: String) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieQueryCell") as? MovieQueryCell else { return UITableViewCell() }
            cell.configure(cellData: element)
            return cell
        }.disposed(by: self.disposeBag)
        
        self.listView.rx.itemSelected.subscribe(onNext: { [weak self] event in
            self?.viewModel.didUserSelectQuery(indexPathRow: event.item)
            self?.viewModel.toggleQueryHidden(flag: true)
        }).disposed(by: self.disposeBag)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
