//
//  GeneralOfferCell.swift
//  MyShot
//
//  Created by Mac on 19/6/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import UIKit

class GeneralOfferCell: UICollectionViewCell {

    var setOffers: GeneralOffers?{
        didSet {
            setupCell()
        }
    }
    
    // MARK: - Let-Var
    @IBOutlet weak var offersImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: SETUPS/LOADERS
    
    func setupCell() {
        
        guard let data = setOffers else{
            print("Issue in dataResponse")
            return
        }
        
        offersImageView.sd_setImage(with: URL(string: data.image!), placeholderImage: #imageLiteral(resourceName: "logoicon"))
        
        titleLabel.text = data.place?.name
        
        
    }
}
