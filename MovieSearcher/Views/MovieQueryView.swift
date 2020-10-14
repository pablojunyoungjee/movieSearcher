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
        listView.rowHeight = 20
    }
    
    func bind() {
        tableViewBind()
    }
    
    //TODO: ViewModel
    func tableViewBind() {
        self.viewModel.movieQueryList.bind(to: self.listView.rx.items) {
            (tableView: UITableView, index: Int, element: String) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieQueryCell") as? MovieQueryCell else { return UITableViewCell() }
            cell.configure(cellData: element)
            return cell
        }.disposed(by: self.disposeBag)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
