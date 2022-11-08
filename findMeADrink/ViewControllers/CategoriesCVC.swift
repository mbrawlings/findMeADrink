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
    private let spacing: CGFloat = 8.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewLayout()
        fetchCategories()
        let categoryNames = UserDefaults.standard.object(forKey: "savedCategories") as? [String]
        if let savedCategories = categoryNames,
           savedCategories.count > 0 {
            categories = savedCategories
        }
    }
    
    //MARK: - HELPER METHODS
    func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView?.collectionViewLayout = layout
    }
    
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
            let categoryToSend = categories[indexPath.row]
            destination.category = categoryToSend
        }
    }

    // MARK: COLLECTION DATA SOURCE
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CategoryCollectionCell else { return UICollectionViewCell() }
        
        let category = categories[indexPath.row]
        
        cell.category = category
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 0.75
        cell.layer.masksToBounds = false
        
        return cell
    }
}

    //MARK: - COLLECTION FLOW LAYOUT
extension CategoriesCVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 2
        let spacingBetweenCells: CGFloat = 8
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = self.collectionView {
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
}
