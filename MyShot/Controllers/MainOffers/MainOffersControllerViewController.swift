//
//  MainOffersControllerViewController.swift
//  MyShot
//
//  Created by Mac on 19/6/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MainOffersControllerViewController: UIViewController, NVActivityIndicatorViewable{
    // MARK: - Let-Var
    var offers = [GeneralOffers]()
    let size = CGSize(width: 30, height: 30)
    var selectedOffers:GeneralOffers?
    // MARK: - Outlets
    @IBOutlet weak var offerCollectionView: UICollectionView!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        gettingData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OffersToDetailsOffersSegue" {
            let detailController = segue.destination as! OfferDetailController
            detailController.generalOffers = selectedOffers
                        
        }
    }
    
    // MARK: - SetUps / Funcs
    
    func setUpUI(){}
    
    func setUpActions(){
        //Delegating collectionview
        offerCollectionView.delegate = self
        offerCollectionView.dataSource = self
        
        //Registering cell at self
        Core.shared.registerCellCollection(at: offerCollectionView, named: "GeneralOfferCell")
    }
    
    private func gettingData(){
        customLoading(at: self)
        CommercesManager().LoadGeneralOffers {
            offer in
            weak var weakSelf = self
            guard let weak = weakSelf else{return}
            guard let offer = offer else{
                self.stopAnimating()
                return
            }
            self.stopAnimating()
            weak.offers = offer
            if weak.offers.count > 0{
                weak.offerCollectionView.reloadData()
                
            }
            
        }
    }
    
    //Custom loading
    func customLoading(at:MainOffersControllerViewController){
        at.startAnimating(size, message: "...", type: NVActivityIndicatorType.orbit)
    }
    
    

}


extension MainOffersControllerViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return offers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  offerCollectionView.dequeueReusableCell(withReuseIdentifier: "GeneralOfferCell", for: indexPath) as? GeneralOfferCell else { return UICollectionViewCell() }
        
        cell.setOffers = offers[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedOffers = offers[indexPath.row]
        
        performSegue(withIdentifier:
            "OffersToDetailsOffersSegue", sender: self)
    }
    
    
}
