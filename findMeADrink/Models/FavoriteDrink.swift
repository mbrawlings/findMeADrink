//
//  FavoriteDrink.swift
//  findMeADrink
//
//  Created by Matthew Rawlings on 11/8/22.
//

import Foundation
import UIKit

class FavoriteDrink: Codable {
    let drinkID: String
    let drinkName: String
    let favoriteHeart: String
    
    init(drinkID: String, drinkName: String, favoriteHeart: String) {
        self.drinkID = drinkID
        self.drinkName = drinkName
        self.favoriteHeart = favoriteHeart
    }
}

extension FavoriteDrink: Equatable {
    static func == (lhs: FavoriteDrink, rhs: FavoriteDrink) -> Bool {
        lhs.drinkID == rhs.drinkID && lhs.drinkName == rhs.drinkName
    }
}
