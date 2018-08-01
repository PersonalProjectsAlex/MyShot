//
//  PlacesCollectionCell.swift
//  MyShot
//
//  Created by Administrador on 21/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import UIKit
import SDWebImage

class PlacesCollectionCell: UICollectionViewCell {


    var commerce: Commerces?{
        didSet {
            setupCell()
        }
    }
    
    
    // MARK: - Let-Var
    var commerces: Commerces?
        // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commerceImageView: UIImageView!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func prepareForReuse() {
        
        commerce = nil
        
    }
    
    // MARK: SETUPS/LOADERS
    
    func setupCell() {
        
        guard let data = commerce else{
            
            commerceImageView.image = #imageLiteral(resourceName: "EmptyStateImage")
            nameLabel.text = "Sin comercios cercanos 😕"
            typeLabel.isHidden = true
            distanceLabel.isHidden = true
            
            return
        }
        
        
        guard let types = data.types, let urlImage =  URL(string: data.image!), let distance = data.distance, let distanceString = data.distance else {return}
        
        nameLabel.text = data.name
        commerceImageView.sd_setImage(with: urlImage, placeholderImage: #imageLiteral(resourceName: "logoicon"))
        
        
        
        typeLabel.text = types.count > 1 ?types.joined(separator: "&") : "Bar"
        
        if distance >= 1{
            distanceLabel.text = "A \(distanceString.rounded()) kms de ti"
        }else{
            distanceLabel.text = "A \(distanceString.rounded()) mts de ti"
        }
       
        
    }
    
    
   
}
