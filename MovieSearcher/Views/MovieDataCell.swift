//
//  MovieDataCell.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/14.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources
import Kingfisher

class MovieDataCell: UITableViewCell, Presentable {
    
    private var disposeBag = DisposeBag()
    
    let posterImageView = UIImageView()
    let verticalStackView = UIStackView()
    let titleLabel = UILabel()
    let linkLabel = UILabel()
    let subTitleLabel = UILabel()
    let pubDateLabel = UILabel()
    let directorLabel = UILabel()
    let actorLabel = UILabel()
    let userRatingLabel = UILabel()
    //TODO: five image collectionView
    
    //TODO: Move to UITableViewCellViewModel
    private let movieImageListRelay: BehaviorRelay<[MovieImage]> = BehaviorRelay(value: [])
    
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
        
        //TODO: Make Custom Image Cache Singleton Logic
        self.disposeBag = DisposeBag()
        self.posterImageView.kf.cancelDownloadTask()
    }
    
    func setupLayout() {
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        linkLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        pubDateLabel.translatesAutoresizingMaskIntoConstraints = false
        directorLabel.translatesAutoresizingMaskIntoConstraints = false
        actorLabel.translatesAutoresizingMaskIntoConstraints = false
        userRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(posterImageView)
        self.contentView.addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(subTitleLabel)
        verticalStackView.addArrangedSubview(directorLabel)
        verticalStackView.addArrangedSubview(actorLabel)
        verticalStackView.addArrangedSubview(pubDateLabel)
        verticalStackView.addArrangedSubview(userRatingLabel)
        verticalStackView.addArrangedSubview(linkLabel)
        
        var constraint: [NSLayoutConstraint] = []
        
        //TODO: Limit, modify posterImageView width, height as ratio
        
        constraint += [posterImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
                       posterImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
                       posterImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
                       posterImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
                       posterImageView.heightAnchor.constraint(equalToConstant: 100),
                       verticalStackView.topAnchor.constraint(equalTo: self.posterImageView.bottomAnchor, constant: 10),
                       verticalStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
                       verticalStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
                       verticalStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(constraint)
    }
    
    func setupStyling() {
        
        //TODO: Limit, modify posterImageView width, height as ratio
        posterImageView.contentMode = .scaleAspectFit
        
        verticalStackView.distribution = .equalSpacing
        verticalStackView.alignment = .fill
        verticalStackView.axis = .vertical
        
        [titleLabel, linkLabel, subTitleLabel, pubDateLabel, directorLabel, actorLabel, userRatingLabel]
            .forEach { $0.numberOfLines = 0 }
    }
    
    func configure(cellData: MovieData) {
        let url = URL(string: cellData.image)
        posterImageView.kf.setImage(with: url)
        titleLabel.text = cellData.title
        linkLabel.text = cellData.link
        subTitleLabel.text = cellData.subTitle
        pubDateLabel.text = cellData.pubDate
        directorLabel.text = cellData.director
        actorLabel.text = cellData.actor
        userRatingLabel.text = cellData.userRating
    }
    
    //TODO: AsDriver
    //TODO: Move to UITableViewCellViewModel
    var movieImageListDataSource: Observable<[MovieImage]> {
        return movieImageListRelay.asObservable()
    }

}
