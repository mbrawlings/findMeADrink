//
//  CategoryCell.swift
//  findMeADrink
//
//  Created by Matthew Rawlings on 11/6/22.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    //MARK: - PROPERTIES
    var category: String? {
        didSet {
                self.setupView()
        }
    }
    
    //MARK: - OUTLETS
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!

    //MARK: - LIFECYCLES
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - HELPER METHODS
    func setupView() {
        guard let category else { return }
        categoryLabel.text = category
        view.layer.cornerRadius = 10
        categoryImage.layer.cornerRadius = 10
        view.backgroundColor = UIColor.systemGray6
        categoryImage.image = UIImage(named: "\(category.lowercased().replacingOccurrences(of: "[/ ^+<>]", with: "", options: .regularExpression))")
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
