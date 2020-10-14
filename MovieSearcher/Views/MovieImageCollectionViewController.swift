//
//  MovieImageViewController.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/15.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import RxDataSources
import RxViewController

class MovieImageCollectionViewController: UIViewController, Presentable {
    
    //TODO: RealViewModel
    let viewModel: MovieImageCollectionViewModel
    private let disposeBag = DisposeBag()
    private var collectionView: UICollectionView!
    
    init(viewModel: MovieImageCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        var constraints: [NSLayoutConstraint] = []
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(collectionView)
        constraints += [collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupStyling() {
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieImageCell.self, forCellWithReuseIdentifier: "MovieImageCell")
    }
    
    func bind(viewModel: MovieImageCollectionViewModel) {
        viewModel.movieImageListDataSource.subscribe ({ [weak self] images in
            self?.collectionView.reloadData()
        }).disposed(by: self.disposeBag)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MovieImageCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 3
        let height = width
        return CGSize(width: width, height: height)
    }
}

extension MovieImageCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movieImageListDataSource.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieImageCell", for: indexPath) as? MovieImageCell else { fatalError("dequeud cell is not MovieImageCell") }
        let cellViewModel = MovieImageCellViewModel(viewModel: viewModel.movieImageListDataSource.value[indexPath.item])
        cell.configure(cellData: cellViewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.loadMoreMovieData(index: indexPath.item)
    }
}
