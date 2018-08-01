//
//  DetailCommercesController+CollectionViewDelegate.swift
//  MyShot
//
//  Created by Administrador on 23/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import Foundation
import UIKit

extension DetailCommercesController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let offers = commerces?.offers{
            return offers.count == 0 ? 0 : offers.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: Constants.offersCell, for: indexPath) as? OffersCell else { return UICollectionViewCell() }
        
        if let offers = commerces?.offers{
            cell.setOffers = offers[indexPath.row]
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let offer = commerces?.offers{
            selectedOffer = offer[indexPath.row]
        }
        
        performSegue(withIdentifier:
            Constants.commerceToOfferDetails, sender: self)
    }
    
    
}
