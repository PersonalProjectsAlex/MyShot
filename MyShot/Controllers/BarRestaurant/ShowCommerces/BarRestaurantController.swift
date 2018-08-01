//
//  BarRestaurantController.swift
//  MyShot
//
//  Created by Administrador on 21/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import UIKit
import MapKit
import PopupDialog
import Hero
import SwiftMessages

class BarRestaurantController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Let-Var
    var commerces = [Commerces]()
    var selectedCommerce:Commerces?
    var offers: Offers?
    let locationManager = CLLocationManager()
    let defaults = UserDefaults.standard
    var userPinView: MKAnnotationView!
    var userLocation: CLLocation?
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up UI elements to be used through the code
        setUpUI()
        
        // setting up general actions/delegates/Core
        setUpActions()
        
        definesPresentationContext = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SwiftMessages.hide()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.barRestaurantSegueToDetail {
            
            let detailController = segue.destination as! DetailCommercesController
            detailController.commerces = selectedCommerce
        }
        
        if segue.identifier == "MapToOfferController"{
            
            let detailController = segue.destination as! OfferDetailController
            detailController.offers = offers
        }
        
    }
    
    // MARK: - SetUps / Funcs
    
    func setUpUI(){
        
    }
    
    func setUpActions(){
        //Collectionview delegate
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Register collectionview cell
        Core.shared.registerCellCollection(at: collectionView, named: Constants.placesCollectionCell)
        
        //Delegating locationmanager
        locationManager.delegate = self
        locationSetting()
        
        //Mapkit
        Core.shared.setMapkitfeatures(mapkit: self.mapKit)
        
        
    }
    
    
    //Parsing Data
    private func gettingData(){
        weak var weakSelf = self
        commerces.removeAll()
        collectionView.reloadData()
        CommercesManager().LoadBars {
            base in
            
            
            guard let commerceArray = base else{return}
            guard let weak = weakSelf else{return}
            weak.commerces = commerceArray
            
            if self.commerces.count > 0{
                weak.collectionView.reloadData()
                weak.getAnnotations(array: weak.commerces)
            }
            
        }
    }
    
    private func gettingData2(lat:Double, lon: Double){
        weak var weakSelf = self
        commerces.removeAll()
        collectionView.reloadData()
        CommercesManager().LoadBarsRegion(lat: lat, lon: lon) {
            base in
            guard let commerceArray = base else{return}
            guard let weak = weakSelf else{return}
            weak.commerces = commerceArray
          
            if self.commerces.count > 0{
                weak.collectionView.reloadData()
                weak.getAnnotations(array: weak.commerces)
                
                guard let safeCommerce = self.commerces.first, let firstOffer = safeCommerce.offers?.first, let countOffer = safeCommerce.offers?.count,  countOffer > 0 else{
                    print("Not offer for first commerce")
                    return
                }
                
                guard let titleOffer = firstOffer.title, let commerceName = safeCommerce.name else{return}
                
                Core.shared.customAlertNavbar(commerceName: commerceName, description: titleOffer).buttonTapHandler = { _ in
                    SwiftMessages.hide()
                    self.offers = firstOffer
                    self.performSegue(withIdentifier: "MapToOfferController", sender: nil)
            
                }
                
                
            }
            
        }
    }
    
    
    func parseDuration(timeString: String) -> TimeInterval {
        
        var interval: Double = 0
        let parts = timeString.components(separatedBy: ":")
        
        guard !timeString.isEmpty else { return 0 }
        
        for (index, part) in parts.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }
        
        return interval
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
        locationManager.startUpdatingLocation()
        
        manager.stopUpdatingLocation()
        manager.stopMonitoringSignificantLocationChanges()
        manager.delegate = nil
        
        settingMap(lat: userLocation.coordinate.latitude, lon: userLocation.coordinate.longitude)
        
        //gettingData2(lat: userLocation.coordinate.latitude, lon: userLocation.coordinate.longitude)
        
        gettingData2(lat: 13.709, lon: -89.243)
        
    }
    
    func settingMap(lat: Double, lon: Double){
        let span = MKCoordinateSpanMake(0.02,0.02)
        let region = MKCoordinateRegionMake(CLLocationCoordinate2D(latitude: lat, longitude: lon), span)
        self.mapKit.setRegion(region, animated: true)
    }
    
    //Settig up location thingss
    func locationSetting(){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                weak.gettingData()
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
                locationManager.startUpdatingLocation()
            }
        } else {
            print("Location services are not enabled")
            weak.gettingData()
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //Creating anottations
    func getAnnotations(array:[Commerces]){
        
        for  i in array{
            guard let lat = i.lat, let lon = i.lon, let logo = i.image else{
                print("Error")
                return
            }
            
            let location = PlacesAnnotations(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon ))
            
            guard let logoURL = URL(string: logo ) else{return}
            
            Core.shared.getDataFromUrl(url: logoURL, completion: { (data, response, error) in
                
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    if data.description != ""{
                        location.logo = UIImage(data: data)
                        
                    }else{
                        location.logo = #imageLiteral(resourceName: "nav")
                    }
                }
            })
          
            self.mapKit.addAnnotation(location)
            
        }
    }
   
    
    
    // MARK: - Objective C
    
}



