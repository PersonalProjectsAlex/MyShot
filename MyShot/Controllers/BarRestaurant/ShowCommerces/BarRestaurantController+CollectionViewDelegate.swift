//
//  BarRestaurantController+CollectionViewDelegate.swift
//  MyShot
//
//  Created by Administrador on 22/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import Foundation
import UIKit

extension BarRestaurantController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commerces.count == 0 ? 1 : commerces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: Constants.placesCollectionCell, for: indexPath) as? PlacesCollectionCell else { return UICollectionViewCell() }
        
        if commerces.count > 0{
            cell.commerce = self.commerces[indexPath.row]
            cell.typeLabel.isHidden = false
            cell.distanceLabel.isHidden = false
            self.collectionView.isScrollEnabled = true
        }else{
            cell.commerceImageView.image = #imageLiteral(resourceName: "EmptyStateImage")
            cell.nameLabel.text = "Sin comercios cercanos 😕"
            cell.typeLabel.isHidden = true
            cell.distanceLabel.isHidden = true
            self.collectionView.isScrollEnabled = false
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if commerces.count > 0{
        selectedCommerce = commerces[indexPath.row]
        performSegue(withIdentifier:
            Constants.barRestaurantSegueToDetail, sender: self)
        }
    }
    
}


