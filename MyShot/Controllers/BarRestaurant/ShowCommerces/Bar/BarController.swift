//
//  BarController.swift
//  MyShot
//
//  Created by Administrador on 28/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//


import UIKit
import MapKit
import PopupDialog
import Hero

class BarController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Let-Var
    var commerces = [Commerces]()
    var selectedCommerce:Commerces?
    let locationManager = CLLocationManager()
    
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
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        gettingData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.barRestaurantSegueToDetail {
            
            let detailController = segue.destination as! DetailCommercesController
            detailController.commerces = selectedCommerce
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
            self.commerces = commerceArray
            
            if self.commerces.count > 0{
                weak.collectionView.reloadData()
                weak.getAnnotations(array: self.commerces)
                
            }
            
        }
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
    }
    
    func settingMap(lat: Double, lon: Double){
        let span = MKCoordinateSpanMake(0.02,0.02)
        let region = MKCoordinateRegionMake(CLLocationCoordinate2D(latitude: lat, longitude: lon), span)
        self.mapKit.setRegion(region, animated: true)
    }
    
    //Settig up location thingss
    func locationSetting(){
        
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
            guard let logoURL = URL(string: logo) else{return}
            
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
