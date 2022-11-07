//
//  CategoriesCVC.swift
//  findMeADrink
//
//  Created by Matthew Rawlings on 11/6/22.
//

import UIKit

private let reuseIdentifier = "categoryCell"

class CategoriesCVC: UICollectionViewController {
    
    //MARK: - PROPERTIES
    var categories: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCategories()
        let categoryNames = UserDefaults.standard.object(forKey: "savedCategories") as? [String]
        if let savedCategories = categoryNames,
           savedCategories.count > 0 {
            categories = savedCategories
        }
    }
    
    //MARK: - HELPER METHODS
    func fetchCategories() {
        CocktailAPIController.fetchCategories { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let drinkCategories):
                    self.categories = drinkCategories
                    self.saveCategories()
                    UIView.transition(with: self.collectionView,
                                              duration: 0.2,
                                              options: .transitionCrossDissolve,
                                              animations: { () -> Void in
                                                self.collectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
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
    // MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFilteredDrinks" {
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first,
                  let destination = segue.destination as? FilteredDrinksTVC
            else { return }
            print(indexPath)
            let categoryToSend = categories[indexPath.row]
            destination.category = categoryToSend
        }
    }

    // MARK: COLLECTION DATA SOURCE
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CategoryCollectionCell {
            
            let category = categories[indexPath.row]
            
            categoryCell.category = category
            
            cell = categoryCell
        }
    
        return cell
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

    //MARK: - COLLECTION FLOW LAYOUT
extension CategoriesCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.row % 2 == 0 {
//
//        }
        return CGSize(width: (UIScreen.main.bounds.width/2)-8, height: (UIScreen.main.bounds.width/2)-8)
    }
}
