//
//  StarbucksAnnotation.swift
//  CustomCalloutView
//
//  Created by Malek Trabelsi on 12/17/17.
//  Copyright © 2017 Medigarage Studios LTD. All rights reserved.
//

import MapKit

class PlacesAnnotations: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var name: String!
    var logo: UIImage!
    
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
