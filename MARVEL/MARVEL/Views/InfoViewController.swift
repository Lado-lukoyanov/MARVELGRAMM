//
//  InfoViewController.swift
//  MARVEL
//
//  Created by Владимир  Лукоянов on 28.11.2022.
//

import UIKit

class InfoViewController: UIViewController {
    
    var heroesArray = [MarvelHeroModel]()
    var heroModel: MarvelHeroModel?
    var randomHeroArray: [MarvelHeroModel] = []
    private let idColletionView = "idColletionView"
 
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private let heroesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    public lazy var imageHeroView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var distLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var exploverLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.text = "Explore more"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        GetRandomAarray()
        setView()
        setUpHeroInfo()
        setConstraint()
        setupDelegate()
    }
    
    private func setView(){
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageHeroView)
        scrollView.addSubview(distLabel)
        scrollView.addSubview(exploverLabel)
        scrollView.addSubview(heroesCollectionView)
    
        navigationController?.navigationBar.tintColor = .white
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        }
        
        heroesCollectionView.register(InfoViewCell.self, forCellWithReuseIdentifier: idColletionView)
    }
// MARK: - Navigation
    private func setupDelegate(){
        
        heroesCollectionView.dataSource = self
        heroesCollectionView.delegate = self
    }
    private func setUpHeroInfo(){
        
        guard let heroModel = heroModel else { return }
        title = heroModel.name
        if heroModel.description == ""{
            distLabel.text = "TOP SECRET"
        } else {
            distLabel.text = heroModel.description
        }
        
        guard let url = heroModel.thumbnail.networkUrl else { return }
        NetworkImageFetch.shared.requestImage(url: url) { [ weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                self.imageHeroView.image = image
            case .failure(_):
                print("allertHero")
            }
        }
    }
    private func GetRandomAarray(){
        while randomHeroArray.count < 8 {
            let random = Int.random(in: 0...heroesArray.count - 1)
            randomHeroArray.append(heroesArray[random])
            let sort = uniqes(sourse: randomHeroArray)
            randomHeroArray = sort
        }
    }
    func uniqes<S : Sequence, T : Hashable>(sourse: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in sourse {
            if !added.contains(elem){
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
  
}

extension InfoViewController: UICollectionViewDataSource {
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        randomHeroArray.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = heroesCollectionView.dequeueReusableCell(withReuseIdentifier: idColletionView, for: indexPath) as! InfoViewCell
        
        let heroModel = randomHeroArray[indexPath.row]
        cell.cofigurateModel(model: heroModel)
        return cell
    }
}

extension InfoViewController: UICollectionViewDelegate {
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let heroModel = randomHeroArray[indexPath.row]
        let infoView = InfoViewController()
        infoView.heroModel = heroModel
        infoView.heroesArray = randomHeroArray
        navigationController?.pushViewController(infoView, animated: true)
    }
    
}

extension InfoViewController: UICollectionViewDelegateFlowLayout {
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: heroesCollectionView.frame.width / 3.02,
               height: heroesCollectionView.frame.width / 3.02)
    }
}

extension InfoViewController {
    
    private func setConstraint(){
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),

            imageHeroView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            imageHeroView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            imageHeroView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            imageHeroView.heightAnchor.constraint(equalToConstant: view.frame.width),
            
            distLabel.topAnchor.constraint(equalTo: imageHeroView.bottomAnchor, constant: 16),
            distLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            distLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            exploverLabel.topAnchor.constraint(equalTo: distLabel.bottomAnchor, constant: 30),
            exploverLabel.bottomAnchor.constraint(equalTo: heroesCollectionView.topAnchor, constant: -5),
            exploverLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            exploverLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -161),
    
            heroesCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            heroesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            heroesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            heroesCollectionView.topAnchor.constraint(equalTo: exploverLabel.bottomAnchor, constant: -10),
            heroesCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10)
        ])
    }
}
