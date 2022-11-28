//
//  InfoViewCell.swift
//  MARVEL
//
//  Created by Владимир  Лукоянов on 28.11.2022.
//

import UIKit

class InfoViewCell: UICollectionViewCell {
    let heroImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraint()
    }
    override func prepareForReuse() {
        heroImage.image = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews() {
        backgroundColor = .none
        addSubview(heroImage)
    }
    func cofigurateModel(model: MarvelHeroModel) {
        guard let url = model.thumbnail.networkUrl else { return }
        NetworkImageFetch.shared.requestImage(url: url) { [ weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                self.heroImage.image = image
            case .failure(_):
                print("alertHero")
            }
        }
    }
  
}
extension InfoViewCell {
    private func setConstraint(){
        NSLayoutConstraint.activate([
            heroImage.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            heroImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            heroImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            heroImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}
