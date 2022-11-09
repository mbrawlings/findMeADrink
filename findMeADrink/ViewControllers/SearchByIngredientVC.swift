//
//  SearchByIngredientVC.swift
//  findMeADrink
//
//  Created by Matthew Rawlings on 11/6/22.
//

import UIKit

class SearchByIngredientVC: UIViewController {
    
    //MARK: - PROPERTIES
    var searchResults: [FilteredCategories.Drink]?
    
    //MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchErrorLabel: UILabel!
    
    //MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchErrorLabel.isHidden = true
        let selectedRow: IndexPath? = tableView.indexPathForSelectedRow
        if let selectedRowNotNil = selectedRow {
            tableView.deselectRow(at: selectedRowNotNil, animated: true)
        }
        searchBar.becomeFirstResponder()
    }
    
    //MARK: - HELPER FUNCTIONS
    func searchBy(ingredient: String) {
        CocktailAPIController.searchBy(ingredient: ingredient) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self.searchErrorLabel.isHidden = true
                    self.searchResults = results
                    self.tableView.reloadData()
                case .failure(let error):
                    self.searchResults = []
                    self.searchErrorLabel.isHidden = false
                    self.tableView.reloadData()
                    self.searchBar.becomeFirstResponder()
                    print(error)
                    print(error.localizedDescription)
                }
            }
        }
    }

    // MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? DetailsVC
            else { return }
            guard let searchResults else { return }
            let idToSend = searchResults[indexPath.row].drinkID
            let drinkNameToSend = searchResults[indexPath.row].drinkName
            destination.drinkID = idToSend
            destination.drinkName = drinkNameToSend
        }
    }
}

    //MARK: - TABLE VIEW
extension SearchByIngredientVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath)
        guard let searchResults else { return UITableViewCell() }
        let searchResult = searchResults[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = searchResult.drinkName
        
        cell.contentConfiguration = content
        
        return cell
    }
}

    //MARK: - SEARCH BAR DELEGATE
extension SearchByIngredientVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchIngredient = searchBar.text else { return }
        searchBy(ingredient: searchIngredient)
        searchBar.resignFirstResponder()
    }
}
