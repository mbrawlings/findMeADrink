//
//  CategoriesTVC.swift
//  findMeADrink
//
//  Created by Matthew Rawlings on 11/1/22.
//

import UIKit

class CategoriesTVC: UITableViewController {
    
    // MARK: - PROPERTIES
    var categories: [String] = []
    
    
    // MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategories()
        tableView.separatorStyle = .none
        let categoryNames = UserDefaults.standard.object(forKey: "savedCategories") as? [String]
        if let savedCategories = categoryNames,
           savedCategories.count > 0 {
            categories = savedCategories
        }
    }
    
    // MARK: - HELPER METHODS
    func fetchCategories() {
        CocktailAPIController.fetchCategories { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let drinkCategories):
                    self.categories = drinkCategories
                    self.saveCategories()
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
    func saveCategories() {
        UserDefaults.standard.set(categories, forKey: "savedCategories")
    }

    // MARK: - TABLE VIEW DATA SOURCE
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryCell else { return UITableViewCell() }

        let category = categories[indexPath.row]
        
        cell.category = category
        
        return cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
//
//        let category = categories[indexPath.row]
//
//        var content = cell.defaultContentConfiguration()
//
//        content.text = category
//
//        cell.contentConfiguration = content
//
//        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.safeAreaLayoutGuide.layoutFrame.size.height
            return height/CGFloat(categories.count)
    }

    // MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFilteredDrinks" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? FilteredDrinksTVC
            else { return }
            let categoryToSend = categories[indexPath.row]
            destination.category = categoryToSend
        }
    }
}
