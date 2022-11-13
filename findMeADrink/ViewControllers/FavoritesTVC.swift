//
//  FavoritesTVC.swift
//  findMeADrink
//
//  Created by Matthew Rawlings on 11/8/22.
//

import UIKit

class FavoritesTVC: UITableViewController {
    
    //MARK: - PROPERTIES
    var favorites: [FavoriteDrink] = []
    
    //MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FavoriteDrinkController.shared.loadFromPersistentStorage()
        favorites = FavoriteDrinkController.shared.favorites
        tableView.separatorStyle = .none
        tableView.reloadData()
    }

    // MARK: - TABLEVIEW DATA SOURCE
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? FavoritesTVCell else { return UITableViewCell() }

        let favorite = favorites[indexPath.row]
        
        cell.drinkName = favorite.drinkName
        
//        var content = cell.defaultContentConfiguration()
//
//        content.text = favorite.drinkName
//
//        cell.contentConfiguration = content

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    // MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? DetailsVC
            else { return }
            let idToSend = favorites[indexPath.row].drinkID
            let drinkNameToSend = favorites[indexPath.row].drinkName
            destination.drinkID = idToSend
            destination.drinkName = drinkNameToSend
        }
    }
}
