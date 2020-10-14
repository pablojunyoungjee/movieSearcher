//
//  MovieImageCell.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/15.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources
import Kingfisher

class MovieImageCell: UICollectionViewCell, Presentable {
    
    private var disposeBag = DisposeBag()
    
    let posterImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        self.posterImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(posterImageView)
        
        var constraints: [NSLayoutConstraint] = []
        
        constraints += [posterImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                        posterImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                        posterImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                        posterImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    //TODO: image ratio
    func setupStyling() {
        
    }
    
    func configure(cellData: MovieImageCellViewModel) {
        let url = URL(string: cellData.thumbNail)
        posterImageView.kf.setImage(with: url)
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        
        posterImageView.kf.cancelDownloadTask()
    }
    
}
