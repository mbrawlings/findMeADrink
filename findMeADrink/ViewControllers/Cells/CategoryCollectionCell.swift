//
//  CategoryCollectionCell.swift
//  findMeADrink
//
//  Created by Matthew Rawlings on 11/6/22.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {
    
    //MARK: - PROPERTIES
    var category: String? {
        didSet {
                self.setupView()
        }
    }
    
    //MARK: - OUTLETS
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    //MARK: - HELPER METHODS
    func setupView() {
        guard let category else { return }
        categoryLabel.text = category
        
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor.systemGray6
        
        categoryImage.layer.cornerRadius = 10
        categoryImage.image = UIImage(named: "\(category.lowercased().replacingOccurrences(of: "[/ ^+<>]", with: "", options: .regularExpression))")
        categoryImage.layer.cornerRadius = 10
    }
}
