//
//  FavoriteDrinkController.swift
//  findMeADrink
//
//  Created by Matthew Rawlings on 11/8/22.
//

import Foundation

class FavoriteDrinkController {
    
    static var shared = FavoriteDrinkController()
    
    var favorites: [FavoriteDrink] = []
    
//    private init(){
//        loadFromPersistentStorage()
//    }
    
    // create new favorite
    func newFavorite(drinkID: String, drinkName: String, favoriteHeart: String) {
        let favorite = FavoriteDrink(drinkID: drinkID, drinkName: drinkName, favoriteHeart: favoriteHeart)
        favorites.append(favorite)
        saveToPersistentStorage()
    }
    
    // delete from storage
    func deleteFavorite(drinkID: String, drinkName: String) {
        let favoriteToDelete = FavoriteDrink(drinkID: drinkID, drinkName: drinkName, favoriteHeart: "")
        guard let index = favorites.firstIndex(of: favoriteToDelete) else { return }
        favorites.remove(at: index)
        saveToPersistentStorage()
    }
    
    // find url location in storage
    func persistentStorage() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = urls[0].appendingPathComponent("favoriteDrinks.json")
        return fileURL
    }
    
    // load from storage
    func loadFromPersistentStorage() {
        do {
            let data = try Data(contentsOf: persistentStorage())
            favorites = try JSONDecoder().decode([FavoriteDrink].self, from: data)
        } catch {
            print("Error loading json from disk \(error)")
        }
    }
    
    // save to storage
    func saveToPersistentStorage() {
        do {
            let data = try JSONEncoder().encode(favorites)
            try data.write(to: persistentStorage())
        } catch {
            print("Error saving favorite drink \(error)")
        }
    }

    
}
