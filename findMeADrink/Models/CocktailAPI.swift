//
//  CocktailAPI.swift
//  findMeADrink
//
//  Created by Matthew Rawlings on 11/1/22.
//

import Foundation

struct Categories: Decodable {
    let drinks: [Drink]

    struct Drink: Decodable {
        let category: String
        
        enum CodingKeys: String, CodingKey {
            case category = "strCategory"
        }
    } // end of drink
} // end of categories

struct FilteredCategories: Decodable {
    let drinks: [Drink]

    struct Drink: Decodable {
        let drinkName: String
        let thumbnailJpg: String?
        let drinkID: String
        
        enum CodingKeys: String, CodingKey {
            case drinkName = "strDrink"
            case thumbnailJpg = "strDrinkThumb"
            case drinkID = "idDrink"
        }
    } // end of drink
} // end of filteredCategories

struct DrinkDetails: Decodable {
    let drinks: [Drink]
    
    struct Drink: Decodable {
        let drinkName: String
        let category: String
        let glass: String?
        let instructions: String?
        let thumbnailJpg: String?
        let ingredient1: String?
        let ingredient2: String?
        let ingredient3: String?
        let ingredient4: String?
        let ingredient5: String?
        let ingredient6: String?
        let ingredient7: String?
        let ingredient8: String?
        let ingredient9: String?
        let ingredient10: String?
        let ingredient11: String?
        let ingredient12: String?
        let ingredient13: String?
        let ingredient14: String?
        let ingredient15: String?
        let measure1: String?
        let measure2: String?
        let measure3: String?
        let measure4: String?
        let measure5: String?
        let measure6: String?
        let measure7: String?
        let measure8: String?
        let measure9: String?
        let measure10: String?
        let measure11: String?
        let measure12: String?
        let measure13: String?
        let measure14: String?
        let measure15: String?
        
        enum CodingKeys: String, CodingKey {
            case drinkName = "strDrink"
            case category = "strCategory"
            case glass = "strGlass"
            case instructions = "strInstructions"
            case thumbnailJpg = "strDrinkThumb"
            case ingredient1 = "strIngredient1"
            case ingredient2 = "strIngredient2"
            case ingredient3 = "strIngredient3"
            case ingredient4 = "strIngredient4"
            case ingredient5 = "strIngredient5"
            case ingredient6 = "strIngredient6"
            case ingredient7 = "strIngredient7"
            case ingredient8 = "strIngredient8"
            case ingredient9 = "strIngredient9"
            case ingredient10 = "strIngredient10"
            case ingredient11 = "strIngredient11"
            case ingredient12 = "strIngredient12"
            case ingredient13 = "strIngredient13"
            case ingredient14 = "strIngredient14"
            case ingredient15 = "strIngredient15"
            case measure1 = "strMeasure1"
            case measure2 = "strMeasure2"
            case measure3 = "strMeasure3"
            case measure4 = "strMeasure4"
            case measure5 = "strMeasure5"
            case measure6 = "strMeasure6"
            case measure7 = "strMeasure7"
            case measure8 = "strMeasure8"
            case measure9 = "strMeasure9"
            case measure10 = "strMeasure10"
            case measure11 = "strMeasure11"
            case measure12 = "strMeasure12"
            case measure13 = "strMeasure13"
            case measure14 = "strMeasure14"
            case measure15 = "strMeasure15"
        }
    } // end of drink
} // end of drinkDetails
