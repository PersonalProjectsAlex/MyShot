//
//  MenuController+CollectionViewDelegate.swift
//  MyShot
//
//  Created by Administrador on 18/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import Foundation
import UIKit
import HexColors

//extension MenuController: UICollectionViewDelegate, UICollectionViewDataSource{
//    
//    // MARK: - CollectionView data source
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return array.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        // get a reference to our storyboard cell
//        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: Constants.menuCollectionCell, for: indexPath) as? MenuCollectionCell else { return UICollectionViewCell() }
//        
//        cell.setMenu = array[indexPath.row]
//        
//        // Change color on cell when has been selected-tapped
//        if let blue = HexColor("#4a78af") {
//            highlightCell(cell: cell, color: blue)
//        }
//      
//        return cell
//    }
//    
//    
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(indexPath.row.description)
//        // get a reference to our storyboard cell
//       let cell = collectionView.cellForItem(at: indexPath) as? MenuCollectionCell
//        
//        switch indexPath.row {
//        case 0:
//            
//            barView.isHidden = true
//            mapandbarView.isHidden = false
//            
//        case 1:
//            barView.isHidden = false
//            mapandbarView.isHidden = true
//        default:
//            array.removeAll()
//            
//            a  = "Rojo"
//            array.append(Menu(itemImage: #imageLiteral(resourceName: "dish"), itemText: "Restaurante", itemColor: .red))
//      
//        }
//        
//    }
//    
//    
//
//
//}

