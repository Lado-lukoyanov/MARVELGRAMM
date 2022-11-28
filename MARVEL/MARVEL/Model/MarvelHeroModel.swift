//
//  MarvelHeroModel.swift
//  MARVEL
//
//  Created by Владимир  Лукоянов on 28.11.2022.
//

import Foundation
struct MarvelHeroModel: Codable {
    let id : Int
    let name: String
    let description: String
    let modified: String
    let thumbnail: Thumbnail
    
struct Thumbnail: Codable {
    let path: String
    let `extension`: String
    var networkUrl: URL? {
        return URL(string: path + "." + `extension`)
    }
    }
}
extension MarvelHeroModel : Hashable {
    static func == (lhs:MarvelHeroModel, rhs: MarvelHeroModel) -> Bool{
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
