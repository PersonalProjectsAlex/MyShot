// Core.swift
// travi
//
// Created by Administrador on 29/03/18.
//
//
import Foundation
import UIKit
import HexColors
import FacebookCore
import FacebookLogin
import MapKit
import SwiftMessages

class Core {
    static let shared = Core()
    private init() {}
    
    //MARK: - UI
    
    //Show Alert Message (function)
     func alert(message: String, title: String, at viewController: UIViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    // Setting custom image onBack Uitabbar
    func setCustomBack(image:UIImage, at: UIViewController){
        var set = image
        set = set.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        if let navigation = at.navigationController?.navigationBar {
        navigation.backIndicatorImage = set
        at.navigationController!.navigationBar.backIndicatorTransitionMaskImage = set
        }
    }
    
    //Custom image on BarButton
    func setImageOnLeftBarButton(image: UIImage, at: UIViewController){
        let imageView = UIImageView(image:image)
        let item = UIBarButtonItem(customView: imageView)
        at.navigationItem.leftBarButtonItem = item
    }
    
    //Function to call a general navigation bar on our screens
    func generalNavigation(at: UIViewController) {
        if let navigationController = at.navigationController?.navigationBar {
            navigationController.barTintColor = HexColor("#EC008C")
            navigationController.isTranslucent = false
            navigationController.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            navigationController.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationController.shadowImage = UIImage()
        }
    }
    
    
    //Set Mapkit
    func setMapkitfeatures(mapkit:MKMapView){
        mapkit.showsUserLocation = true
        mapkit.isZoomEnabled = true
        mapkit.showsTraffic = true
        mapkit.mapType = .standard
        mapkit.showsBuildings = true
        mapkit.showsPointsOfInterest = true
    }
    
    //Set Image on navbar
    func SetImageOnNavBar(at:UIViewController, image: UIImage){
        let imageView = UIImageView(image:image)
        imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        at.navigationItem.titleView = imageView
    }
    
    // MARK. -Helpers
    
    func setStoryBoardName(storyboard: String, controller: String, at: UIViewController) -> UIViewController{
        return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: controller)
        
    }
    
    //getting some dat fro a custom URL for the most part with images
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    //Create QR
    func generateQR(imageview: UIImageView, encode: String){
        var filter:CIFilter!
        filter = CIFilter(name: "CIQRCodeGenerator")
        let dataString = encode
        let data = dataString.data(using: String.Encoding.utf8)
        filter.setValue("H", forKey:"inputCorrectionLevel")
        filter.setValue(data, forKey:"inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let qrImage = UIImage(ciImage: filter.outputImage!.transformed(by: transform))
        imageview.image = qrImage
        imageview.sizeToFit()
        imageview.contentMode = .scaleAspectFit
    }
    
    //Show custom message from navbar
    func customAlertNavbar(commerceName: String, description: String)->MessageView{
        //Setting view and custom config
        
        let view = MessageView.viewFromNib(layout: .messageView)
        var config = SwiftMessages.Config()
        // Theme message elements with the warning style.
        view.configureTheme(.success)
        view.button?.setTitle("Ver oferta", for: .normal)
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        
        // Add a drop shadow.
        view.configureDropShadow()
        
        // Slide down from the tp.
        config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        config.preferredStatusBarStyle = .lightContent
        config.duration = .forever
        // Set message title, body, and icon. Here, we're overriding the default warning
        // image with an emoji character.
        let iconText = "😱"
        view.titleLabel?.textColor = HexColor(Colors.mainColor)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        view.bodyLabel?.font = UIFont.systemFont(ofSize: 15.0)
        view.configureContent(title: commerceName, body: description, iconText: iconText)
        
        // Show the message.
        SwiftMessages.show(config: config, view: view)
        return view
    }
    
    //Logout core
    func logoutNavigation(at: UIViewController){
        at.dismiss(animated: true, completion: nil)
        let initialViewController = UIStoryboard(name: "Authentication", bundle:nil).instantiateInitialViewController() as! LaunchController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = initialViewController
    }
    
    // MARK. -Components
    
    
    
    // Register cell at a table view
    func registerCell(at tableView: UITableView, named: String, withIdentifier: String? = nil) {
        let cellNib = UINib(nibName: named, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: withIdentifier ?? named)
    }
    
    // Register cell at a table view
    func registerCellCollection(at collectionView: UICollectionView, named: String, withIdentifier: String? = nil) {
        let cellNib = UINib(nibName: named, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: withIdentifier ?? named)
    }
    
}



