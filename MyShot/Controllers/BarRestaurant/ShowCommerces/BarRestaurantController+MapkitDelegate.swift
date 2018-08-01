//
//  BarRestaurantController+MapkitDelegate.swift
//  MyShot
//
//  Created by Administrador on 22/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SDWebImage
import NVActivityIndicatorView

extension BarRestaurantController: MKMapViewDelegate, NVActivityIndicatorViewable{
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {}
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let pin = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            
            if let profile = defaults.string(forKey: "userPhoto") {
                if let urlImage =  URL(string: profile){
                
                Core.shared.getDataFromUrl(url: urlImage, completion: { (data, response, error) in
                    
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() {
                        if data.description != ""{
                            guard let setImage = UIImage(data: data) else{return}
                            pin.image = self.scaledImage(setImage, maximumWidth: 40)
                            
                            
                        }else{
                            pin.image = self.scaledImage(UIImage(named: "pin")!, maximumWidth: 40)
                        }
                    }
                })
            }
            }
            userPinView = pin
            return pin
        }
        
        var annotationView = self.mapKit.dequeueReusableAnnotationView(withIdentifier: "Pin")
        
        if annotationView == nil{
            
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }
        else{ annotationView?.annotation = annotation }
        
        annotationView?.image = UIImage(named: "ico")
        
        return annotationView
        
        
    
    }
    
    func scaledImage(_ image: UIImage, maximumWidth: CGFloat) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let cgImage: CGImage = image.cgImage!.cropping(to: rect)!
        return UIImage(cgImage: cgImage, scale: image.size.width / maximumWidth, orientation: image.imageOrientation)
    }
    
    
    
    
    func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view: UIView? = mapKit?.subviews.first
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        for recognizer: UIGestureRecognizer in (view?.gestureRecognizers)! {
            if recognizer.state == .began || recognizer.state == .ended {
                return true
            }
        }
        return false
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        
        let reuseId = "Pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.isDraggable = true
        }
        else {
            pinView?.annotation = annotation
            
        }
        
        return pinView
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if newState == MKAnnotationViewDragState.ending {
            let droppedAt = view.annotation?.coordinate
            
        }
    }
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        
        // 1
        if view.annotation is MKUserLocation
        {
            // Don't proceed with custom callout
            return
        }
        
        // 2
        let placeAnnotation = view.annotation as! PlacesAnnotations
        
        
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomCalloutView
        
        calloutView.iconShopsImageView.image = placeAnnotation.logo
        
        
        if self.mapKit.selectedAnnotations.count > 0 {
            
         
        }
        // Don't proceed with custom calloutz
        if view.annotation is MKUserLocation {}
        
        
        //let button = UIButton(frame: calloutView.iconShopsImageView.frame)
        
        
        //calloutView.addSubview(button)
        
        // 3
                calloutView.center = CGPoint(x: view.bounds.size.width, y: -calloutView.bounds.size.height*0.46)
        calloutView.center = CGPoint(x: 0, y: -calloutView.bounds.size.height / 2)
        view.addSubview(calloutView)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        
    }
    
    
    
    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        
        if view.isKind(of: AnnotationView.self) {
            
            
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
        }
    }
    
    
    
}


extension UIImage {
    
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(self.cgImage!, in: newRect)
            let newImage = UIImage(cgImage: context.makeImage()!)
            UIGraphicsEndImageContext()
            return newImage
        }
        return nil
    }
    
    //Custom loading
    func customLoading(at:BarRestaurantController){
        at.startAnimating(size, message: "...", type: NVActivityIndicatorType.orbit)
    }
}
