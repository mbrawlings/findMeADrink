//
//  DrinksTVCell.swift
//  findMeADrink
//
//  Created by Matthew Rawlings on 11/13/22.
//

import UIKit

class DrinksTVCell: UITableViewCell {
    
    //MARK: - PROPERTIES
    var drinkName: String? {
        didSet {
            setupView()
        }
    }
    
    //MARK: - OUTLETS
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var drinkLabel: UILabel!
    
    //MARK: - LIFECYCLES
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - HELPER METHODS
    func setupView() {
        guard let drinkName else { return }
        drinkLabel.text = drinkName
        
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 2.0
        view.layer.shadowOpacity = 0.75
        view.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
