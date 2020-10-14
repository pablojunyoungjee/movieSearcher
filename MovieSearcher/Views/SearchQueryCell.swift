//
//  SearchQueryCell.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/15.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources

//TODO: CELLVIEWMODEL
class SearchQueryCell: UITableViewCell, Presentable {

    private var disposeBag = DisposeBag()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupStyling()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
    }
    
    func setupLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        
        var constraint: [NSLayoutConstraint] = []
        
        constraint += [titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
                       titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 4),
                       titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -4),
                       titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4)
        ]
        
        NSLayoutConstraint.activate(constraint)
    }
    
    func setupStyling() {
        titleLabel.textColor = .lightGray
        titleLabel.font = UIFont.systemFont(ofSize: 6)
    }
}
