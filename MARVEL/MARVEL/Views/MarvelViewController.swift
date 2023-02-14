//
//  MarvelViewController.swift
//  MARVEL
//
//  Created by Владимир  Лукоянов on 28.11.2022.
//
import UIKit

class MarvelViewController: UIViewController {
    
    private let logoImage = UIImage(named: "Logo")
    private let idColletionView = "idColletionView"
    private var isfiltred = false
    private var filtredArray = [IndexPath]()
    let searchController = UISearchController()
    private var heroesArray = [MarvelHeroModel]()
    
    private let heroesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private lazy var logoView: UIImageView = {
        let image = UIImageView()
        image.image = logoImage
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkigCollection()
        setupView()
        setupDelegate()
        
    }

// MARK: - SetupView
    private func setupView(){
        view.backgroundColor = #colorLiteral(red: 0.1516073942, green: 0.1516073942, blue: 0.1516073942, alpha: 1)
        view.addSubview(heroesCollectionView)
        setConstraint()
        heroesCollectionView.register(HeroCollectionCell.self, forCellWithReuseIdentifier: idColletionView)
        setNavigation()
    }
    private func setNavigation(){
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        navigationItem.backButtonTitle = ""
        navigationItem.titleView = createCustomTitleView()
        navigationItem.hidesSearchBarWhenScrolling = false
        
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.standardAppearance.backgroundColor = #colorLiteral(red: 0.1516073942, green: 0.1516073942, blue: 0.1516073942, alpha: 1)
            navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = #colorLiteral(red: 0.1516073942, green: 0.1516073942, blue: 0.1516073942, alpha: 1)
        }
    }
    
// MARK: - Setup CollectionView
    private func setupDelegate(){
        
        heroesCollectionView.dataSource = self
        heroesCollectionView.delegate = self
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
    }
    
    private func createCustomTitleView() -> UIView {
        let view = UIView()
        let heightNavBar = navigationController?.navigationBar.frame.height ?? 0
        let widthNavBar = navigationController?.navigationBar.frame.width ?? 0
        view.frame = CGRect(x: 0, y: 0, width: widthNavBar, height: heightNavBar - 10)
        
        let marvelImageView = UIImageView()
        marvelImageView.image = UIImage(named: "Logo")
        marvelImageView.contentMode = .left
        marvelImageView.frame = CGRect(x: 10, y: 0, width: widthNavBar , height: heightNavBar / 2)
        view.addSubview(marvelImageView)
        return view
    }
    private func networkigCollection(){
        
        NetworkDataFetch.shared.fetchHero { [ weak self ] marvelHeroArray, error in
            guard let self = self else { return }
            if error != nil {
                print("alert")
            } else {
                guard let marvelHeroArray = marvelHeroArray else { return }
                
                self.heroesArray = marvelHeroArray
                self.heroesCollectionView.reloadData()
            }
        }
    }
    private func setAlfaforCell(alpha: Double){
        heroesCollectionView.visibleCells.forEach { cell in
            cell.alpha = alpha
        }
    }
}
// MARK: - Extension
extension MarvelViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        heroesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = heroesCollectionView.dequeueReusableCell(withReuseIdentifier: idColletionView, for: indexPath) as! HeroCollectionCell
        
        let heroModel = heroesArray[indexPath.row]
        cell.cofigurateModel(model: heroModel)
        return cell
    }
}
extension MarvelViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let heroModel = heroesArray[indexPath.row]
        let infoView = InfoViewController()
        infoView.heroModel = heroModel
        infoView.heroesArray = heroesArray
        navigationController?.pushViewController(infoView, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if isfiltred {
            cell.alpha = (filtredArray.contains(indexPath) ? 1 : 0.3)
        }
    }
}

extension MarvelViewController: UISearchControllerDelegate {
    
    func didPresentSearchController(_ searchController: UISearchController) {
        
        isfiltred = true
        setAlfaforCell(alpha: 0.3)
    }
    func didDismissSearchController(_ searchController: UISearchController) {
        
        isfiltred = false
        setAlfaforCell(alpha: 1)
        self.heroesCollectionView.reloadData()
    }
}

extension MarvelViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filterContentForSearchText(text)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        for (value, hero) in heroesArray.enumerated() {
            let indexPath: IndexPath = [0, value]
            let cell = heroesCollectionView.cellForItem(at: indexPath)
            if hero.name.lowercased().contains(searchText.lowercased()){
                filtredArray.append(indexPath)
                cell?.alpha = 1
            } else {
                cell?.alpha = 0.3
            }
        }
    }
}

extension MarvelViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: heroesCollectionView.frame.width / 3.02,
               height: heroesCollectionView.frame.width / 3.02)
    }
}

extension MarvelViewController {
    private func setConstraint(){
        
        NSLayoutConstraint.activate([
            heroesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            heroesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            heroesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            heroesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}
