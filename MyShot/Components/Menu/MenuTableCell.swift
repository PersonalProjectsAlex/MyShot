//
//  MenuTableCell.swift
//  MyShot
//
//  Created by Administrador on 18/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import UIKit

class MenuTableCell: UITableViewCell {

    var setMenu: Menu?{
        didSet {
            setupCell()
        }
    }
    
    
    // MARK: - Let-Var
    var menu: Menu?
    // MARK: - Outlets
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var setColorView: UIView!
    
    override func prepareForReuse() {
        setMenu = nil
    }
    
    // MARK: SETUPS/LOADERS
    
    func setupCell() {
        
        guard let data = setMenu else{
            print("Issue in dataResponse")
            return
        }
        
        itemLabel.text = data.itemText
        menuImageView.image = data.itemImage
        setColorView.backgroundColor = data.itemColor
    }
    
    
    
}
