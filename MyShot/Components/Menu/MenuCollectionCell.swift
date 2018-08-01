//
//  MenuCollectionCell.swift
//  MyShot
//
//  Created by Administrador on 18/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import UIKit

class MenuCollectionCell: UICollectionViewCell {
    var setMenu: Menu?{
        didSet {
            setupCell()
        }
    }
    
    
    
    // MARK: - Let-Var
    var menu: Menu?
    
    @IBOutlet weak var menuImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            menuImageView.image?.withRenderingMode(.alwaysTemplate)
            menuImageView.tintColor = UIColor.blue
        }
    }
    // MARK: SETUPS/LOADERS
    
    func setupCell() {
        
        guard let data = setMenu else{
            print("Issue in dataResponse")
            return
        }
        
        
        menuImageView.image = data.itemImage
        titleLabel.text = data.itemText
        
    }
    
}
