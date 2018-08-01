//
//  OffersCell.swift
//  MyShot
//
//  Created by Administrador on 23/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import UIKit
import SDWebImage

class OffersCell: UICollectionViewCell {

    var setOffers: Offers?{
        didSet {
            setupCell()
        }
    }
    
    // MARK: - Let-Var
    var menu: Offers?
    
    @IBOutlet weak var offersImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overdueLabel: UILabel!
    
    
    // MARK: SETUPS/LOADERS
    
    func setupCell() {
        
        guard let data = setOffers else{
            print("Issue in dataResponse")
            return
        }
        
        
        offersImageView.sd_setImage(with: URL(string: data.image!), placeholderImage: #imageLiteral(resourceName: "logoicon"))
        
        //titleLabel.text = data.title
        
        
    }

}
