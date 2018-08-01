//
//  OfferDetailController.swift
//  MyShot
//
//  Created by Administrador on 23/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import UIKit
import SDWebImage

class OfferDetailController: UIViewController {
    
    // MARK: - Let-Var
    var commerces: Commerces?
    var offers: Offers?
    var generalOffers: GeneralOffers?
    var filter:CIFilter!
    // MARK: - Outlets
    
    @IBOutlet weak var qrImageview: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var commerceImagview: UIImageView!
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //guard let code = offer.code else{return}
        //guard let image = offer.image else{return}
        
        //guard let imagecommerce = generalOffers?.place?.image else{return}
       // guard let codecommerce = generalOffers?.code else{return}
        //let selectedcode = code.isEmpty ? code : codecommerce
        if  let code = generalOffers?.code{
            Core.shared.generateQR(imageview: self.qrImageview, encode: code)
        }
        
        if  let code = offers?.code{
            Core.shared.generateQR(imageview: self.qrImageview, encode: code)
        }
        
        if  let title = offers?.title{
            titleLabel.text = title
        }
        
        if  let title = generalOffers?.title{
            titleLabel.text = title
        }
        
        if  let offerimage = generalOffers?.image{
            offerImageView.sd_setImage(with: URL(string: offerimage), placeholderImage: #imageLiteral(resourceName: "EmptyStateImage"))
        }
        
        if  let offerimage = offers?.image{
            offerImageView.sd_setImage(with: URL(string: offerimage), placeholderImage: #imageLiteral(resourceName: "EmptyStateImage"))
        }
        
        if  let commerceimage = generalOffers?.place?.image{
            commerceImagview.sd_setImage(with: URL(string: commerceimage), placeholderImage: #imageLiteral(resourceName: "logoicon"))
        }
        
        if  let commerceimage = commerces?.image{
            commerceImagview.sd_setImage(with: URL(string: commerceimage), placeholderImage: #imageLiteral(resourceName: "logoicon"))
        }
        
        
       // guard let imageCommerce = commerces?.image else { return }
        //commerceImagview.sd_setImage(with: URL(string: imageCommerce), placeholderImage: #imageLiteral(resourceName: "logoicon"))
        //Setting status bar none
        
        self.modalPresentationCapturesStatusBarAppearance = true
    }
    
    
    
    // MARK: - SetUps / Funcs
    
    //Dimissing our Controller
    @IBAction func closeDetails(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Hidding status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
