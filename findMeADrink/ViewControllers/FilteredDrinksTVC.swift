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
        guard let category else { return }
        // read/get data
        if let data = UserDefaults.standard.data(forKey: "\(category)SavedDrinks") {
            do {
                let savedDrinks = try JSONDecoder().decode([FilteredCategories.Drink].self, from: data)
                filteredDrinks = savedDrinks
            } catch {
                print(error)
                print(error.localizedDescription)
                print("Could not decode UD data")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    //MARK: - HELPER METHODS
    func fetchFilteredDrinks() {
        guard let category else { return }
        CocktailAPIController.filterBy(category: category) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let drinks):
                    self.filteredDrinks = drinks
                    self.saveDrinks()
                    UIView.transition(with: self.tableView,
                                              duration: 0.2,
                                              options: .transitionCrossDissolve,
                                              animations: { () -> Void in
                                                self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
                                              },
                                              completion: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    func saveDrinks() {
        guard let category else { return }
        // write/set the data
        do {
            let drinkData = try JSONEncoder().encode(filteredDrinks)
            UserDefaults.standard.set(drinkData, forKey: "\(category)SavedDrinks")
        } catch {
            print(error)
            print(error.localizedDescription)
            print("Unable to Encode Array of Drink")
        }
    }
    func setupView() {
        guard let category else { return }
        self.title = category
        tableView.separatorStyle = .none
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "drinkCell", for: indexPath) as? DrinksTVCell else { return UITableViewCell() }
        
        var drink: FilteredCategories.Drink?
        
        if isSearching {
            drink = searchedDrinks[indexPath.row]
        } else {
            drink = filteredDrinks[indexPath.row]
        }
        
        cell.drinkName = drink?.drinkName
        
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
            let idToSend: String?
            let drinkNameToSend: String?
            if isSearching {
                idToSend = searchedDrinks[indexPath.row].drinkID
                drinkNameToSend = searchedDrinks[indexPath.row].drinkName
            } else {
                idToSend = filteredDrinks[indexPath.row].drinkID
                drinkNameToSend = filteredDrinks[indexPath.row].drinkName
            }
            destination.drinkID = idToSend
            destination.drinkName = drinkNameToSend
            
            if searchBar.text == "" {
                searchBar.resignFirstResponder()
            }
        }
    }
}

    //MARK: - SEARCH BAR DELEGATE
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
