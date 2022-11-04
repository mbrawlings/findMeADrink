//
//  FilteredDrinksTVC.swift
//  findMeADrink
//
//  Created by Matthew Rawlings on 11/2/22.
//

import UIKit

class FilteredDrinksTVC: UITableViewController {
    
    //MARK: - PROPERTIES
    var filteredDrinks: [FilteredCategories.Drink] = []
    var searchedDrinks: [FilteredCategories.Drink] = []
    var category: String?
    var isSearching = false
    
    //MARK: - OUTLETS
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        fetchFilteredDrinks()
        setupView()
    }

    //MARK: - HELPER METHODS
    func fetchFilteredDrinks() {
        guard let category else { return }
        CocktailAPIController.filterBy(category: category) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let drinks):
                    self.filteredDrinks = drinks
                    UIView.transition(with: self.tableView,
                                              duration: 0.2,
                                              options: .transitionCrossDissolve,
                                              animations: { () -> Void in
                                                self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
                                              },
                                              completion: nil)
//                    self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    func setupView() {
        guard let category else { return }
        self.title = category
    }
    
    
    // MARK: - TABLE VIEW DATA SOURCE
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchedDrinks.count
        } else {
            return filteredDrinks.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drinkCell", for: indexPath)
        
        var drink: FilteredCategories.Drink?
        
        if isSearching {
            drink = searchedDrinks[indexPath.row]
        } else {
            drink = filteredDrinks[indexPath.row]
        }
        
        var content = cell.defaultContentConfiguration()
        guard let drink else { return UITableViewCell() }
        content.text = drink.drinkName
        cell.contentConfiguration = content
        
//        let imageUrl = URL(string: drink.thumbnailJpg)
//        DispatchQueue.global().async {
//            let imageData = try? Data(contentsOf: imageUrl!)
//            DispatchQueue.main.async {
//                guard let data = imageData else { return }
//                content.image = UIImage(data: data)
//                content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
//                tableView.reloadData()
//            }
//        }
        return cell
    }

    // MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? DetailsVC
            else { return }
            let idToSend = filteredDrinks[indexPath.row].drinkID
            let drinkNameToSend = filteredDrinks[indexPath.row].drinkName
            destination.drinkID = idToSend
            destination.drinkName = drinkNameToSend
        }
    }
}

extension FilteredDrinksTVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        searchedDrinks = filteredDrinks
        
        let searchText = searchText.lowercased()
        if !searchText.isEmpty {
            searchedDrinks = filteredDrinks.filter { ($0.drinkName.lowercased().contains(searchText)) }
        } else {
            searchedDrinks = filteredDrinks
        }
        tableView.reloadData()
    }
}
