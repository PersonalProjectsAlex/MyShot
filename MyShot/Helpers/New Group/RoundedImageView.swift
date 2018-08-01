//
//  RoundedImageView.swift
//  MyShot
//
//  Created by Administrador on 27/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
}
