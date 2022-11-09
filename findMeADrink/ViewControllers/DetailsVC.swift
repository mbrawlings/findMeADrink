//
//  DetailsVC.swift
//  findMeADrink
//
//  Created by Matthew Rawlings on 11/2/22.
//

import UIKit

class DetailsVC: UIViewController {
    
    //MARK: - PROPERTIES
    var drinkID: String?
    var drinkName: String?
    var favoriteHeart: String = "heart"
    var drinkDetails: [DrinkDetails.Drink] = []
    var ingredients: [String] = []
    var measurements: [String] = []
    
    //MARK: - OUTLETS
    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var instructionsLabel: UITextView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var drinkImageViewContainer: UIView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    //MARK: - LIFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        title = drinkName
        fetchDetails()
        ingredientsTableView.reloadData()
    }
    
    //MARK: - ACTION
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        if favoriteButton.image == UIImage(systemName: "heart") {
            favoriteHeart = "heart.fill"
            guard let drinkID,
                  let drinkName
            else { return }
            FavoriteDrinkController.shared.newFavorite(drinkID: drinkID, drinkName: drinkName, favoriteHeart: favoriteHeart)
            favoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            favoriteHeart = "heart"
            guard let drinkID,
                  let drinkName
            else { return }
            FavoriteDrinkController.shared.deleteFavorite(drinkID: drinkID, drinkName: drinkName)
            favoriteButton.image = UIImage(systemName: "heart")
        }
    }
    
    func fetchDetails() {
        guard let drinkID else { return }
        CocktailAPIController.fetchDetailsBy(id: drinkID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let drinkDetails):
                    self.drinkDetails = drinkDetails
                    self.organizeData()
                    self.setupViews()
                    self.ingredientsTableView.reloadData()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func setupViews() {
        let details = drinkDetails[0]
        // set favorite symbol
        guard let drinkID,
              let drinkName
        else { return }
        let thisDrink = FavoriteDrink(drinkID: drinkID, drinkName: drinkName, favoriteHeart: "")
        if FavoriteDrinkController.shared.favorites.contains(thisDrink) {
            favoriteButton.image = UIImage(systemName: "heart.fill")
        }
        // image url -> data -> UIImage
        let imageUrl = URL(string: details.thumbnailJpg ?? "")
        DispatchQueue.global().async {
        let imageData = try? Data(contentsOf: imageUrl!)
            DispatchQueue.main.async {
                guard let data = imageData else { return }
                self.drinkImage.image = UIImage(data: data)
                self.instructionsLabel.text = details.instructions
                
                UIView.animate(withDuration: 0.4, animations: {
                    self.spinner.alpha = 0.0
                }) { complete in
                    self.spinner.stopAnimating()
                }
            }
        }
        
        drinkImageViewContainer.layer.shadowColor = UIColor.black.cgColor
        drinkImageViewContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
        drinkImageViewContainer.layer.shadowRadius = 5.0
        drinkImageViewContainer.layer.shadowOpacity = 0.75
        drinkImageViewContainer.layer.masksToBounds = false
        drinkImageViewContainer.layer.cornerRadius = 10
        
        drinkImage.layer.masksToBounds = true
        drinkImage.layer.cornerRadius = 10
        
        ingredientsTableView.layer.borderWidth = 0.5
        ingredientsTableView.layer.borderColor = UIColor.gray.cgColor
        ingredientsTableView.layer.cornerRadius = 10
                
        instructionsLabel.layer.borderWidth = 0.5
        instructionsLabel.layer.borderColor = UIColor.gray.cgColor
        instructionsLabel.layer.cornerRadius = 10
        instructionsLabel.backgroundColor = UIColor.systemGray6
    }
    
    func organizeData() {
        let details = drinkDetails[0]
        let rawIngredients = [ "Preferred glass", details.ingredient1, details.ingredient2, details.ingredient3, details.ingredient4, details.ingredient5, details.ingredient6, details.ingredient7, details.ingredient8, details.ingredient9, details.ingredient10, details.ingredient11, details.ingredient12, details.ingredient13, details.ingredient14, details.ingredient15 ]
        ingredients = rawIngredients.compactMap { ($0) }
        let rawMeasurements = [ details.glass, details.measure1, details.measure2, details.measure3, details.measure4, details.measure5, details.measure6, details.measure7, details.measure8, details.measure9, details.measure10, details.measure11, details.measure12, details.measure13, details.measure14, details.measure15 ]
        measurements = rawMeasurements.compactMap { ($0) }
    }
}

    //MARK: - TABLEVIEW
extension DetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.backgroundColor = UIColor.systemGray6
        cell.backgroundColor = UIColor.systemGray6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        
        if ingredients.count > measurements.count {
            let ingredientCount = ingredients.count
            var measurementCount = measurements.count
            while ingredientCount != measurementCount {
                measurements.append("")
                measurementCount += 1
            }
        } else {
            var ingredientCount = ingredients.count
            let measurementCount = measurements.count
            while ingredientCount != measurementCount {
                ingredients.append("")
                ingredientCount += 1            }
        }
        
        let ingredient = ingredients[indexPath.row]
        let measurement = measurements[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = ingredient
        content.secondaryText = String(measurement.filter { !"\n\t\r".contains($0) })
                
        cell.contentConfiguration = content
        
        return cell
    }
}
