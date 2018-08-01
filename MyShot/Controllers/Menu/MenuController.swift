//
//  MenuController.swift
//  MyShot
//
//  Created by Administrador on 18/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import UIKit
import HexColors
import PopupDialog
import CoreLocation
import Hero
import SwiftMessages

class MenuController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Let-Var
    var a = "Hola"
    var array = [Menu]()
    let locationManager = CLLocationManager()
    let defaults = UserDefaults.standard
    var isLiked = Bool()
    var isLikedOpt2 = Bool()
    // MARK: - Outlets
    @IBOutlet weak var mapandbarView: UIView!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
        
        definesPresentationContext = true
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    // MARK: - SetUps / Funcs
    
    func setUpUI(){
        //setting general
        Core.shared.generalNavigation(at: self)
        
        //Showing Dialog
        DispatchQueue.main.async {
            guard let accepted = self.defaults.string(forKey: "termAccepted") else {
            self.showCustomDialog(animated: true)
            return
        }
       
        }
    }
    
    func setUpActions(){
        
        //Collectionview delegate
        
        //Register collectionview cell
        
        
        //Setting first element by default at collectioncell
        
        
        //Delegating locationmanager
        locationManager.delegate = self
        
        //Set Main view
        barView.isHidden = true
        mapandbarView.isHidden = false
        
    }
    
    //Showing dialog to ask location
    func showCustomDialog(animated: Bool = true) {
    
        weak var weakSelf = self
        // Create a custom view controller
        let ratingVC = LocationPopup(nibName: "LocationPopup", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: ratingVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        
        let buttonOne = CancelButton(title: "No Acepto", height: 60) {
            
        }
        
        let buttonTwo = DefaultButton(title: "Acepto", height: 60) {
            guard let weak = weakSelf else{return}
            weak.locationSetting()
            weak.defaults.set("accepted", forKey: "termAccepted")
        }
        
        popup.addButtons([buttonOne, buttonTwo])
        // Present dialog
        present(popup, animated: animated, completion: nil)
    }
    
    
    func locationSetting(){
        locationManager.requestWhenInUseAuthorization()
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
                locationManager.startUpdatingLocation()
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    @IBAction func selectedOption1(_ sender: UIButton) {
        isLiked = true
        if isLiked == true {
            option1Button.setImage(#imageLiteral(resourceName: "icon1"), for: UIControlState())
            option2Button.setImage(#imageLiteral(resourceName: "icon2"), for: UIControlState())
            barView.isHidden = true
            mapandbarView.isHidden = false
        }
        
    }
    
    @IBAction func selectedOption2(_ sender: UIButton) {
        isLikedOpt2 = true
        if isLikedOpt2 == true {
            option2Button.setImage(#imageLiteral(resourceName: "icon4"), for: UIControlState())
            option1Button.setImage(#imageLiteral(resourceName: "icon3"), for: UIControlState())
            SwiftMessages.hide()
            barView.isHidden = false
            mapandbarView.isHidden = true
            }
        
    }
    
    func highlightCell(cell: MenuCollectionCell, color: UIColor){
        let bgColorView = UIView()
        bgColorView.backgroundColor = color
        cell.selectedBackgroundView = bgColorView
        
    }

//    func optionsMenu(){
//        array.append(Menu(itemImage: #imageLiteral(resourceName: "cheers"), itemText: "Bar", itemColor: HexColor("335379")))
//        array.append(Menu(itemImage: #imageLiteral(resourceName: "dish"), itemText: "Bar & Restaurante", itemColor: HexColor("335379")))
//
//    }
}
