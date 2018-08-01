//
//  DetailCommercesController.swift
//  MyShot
//
//  Created by Administrador on 22/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import UIKit
import ImageSlideshow
import Kingfisher
import HexColors
import Hero
import Cosmos

class DetailCommercesController: UIViewController {
    // MARK: - Let-Var
    var commerces: Commerces?
    var selectedOffer: Offers?
    var images = [KingfisherSource]()
    var imagePlaceHolder = [ImageSource]()
    
    // MARK: - Outlets
    @IBOutlet var slideshow: ImageSlideshow!
    @IBOutlet weak var maskingUIView: UIView!
    @IBOutlet weak var offersCollectionView: UICollectionView!
    @IBOutlet weak var phoneNumberLabel: UIButton!
    @IBOutlet weak var wazeButton: UIButton!
    @IBOutlet weak var googleMapButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up UI elements to be used through the code
        setUpUI()
        
        // setting up general actions/delegates/Core
        setUpActions()
     
    }
    override func viewWillAppear(_ animated: Bool) {
        scrollView.scrollToTop(animated: true)
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.commerceToOfferDetails {
            
            let detailController = segue.destination as! OfferDetailController
            detailController.offers = selectedOffer
            detailController.commerces = commerces
        }
        if segue.identifier == "DetailsToCommentsSegue"{
            
            let detailController = segue.destination as! CommerceCommentTableController
            detailController.commerces = commerces
        }
        
        
    }

    // MARK: - SetUps / Funcs
    
    func setUpUI(){
        //Images on button fit
        wazeButton.imageView?.contentMode = .scaleAspectFit
        googleMapButton.imageView?.contentMode = .scaleAspectFit
        facebookButton.imageView?.contentMode = .scaleAspectFit
        instagramButton.imageView?.contentMode = .scaleAspectFit
        wazeButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
        wazeButton.imageView?.tintColor = .white
        
        self.hero.isEnabled = true
        self.hero.modalAnimationType = .zoom
    }
    
    func setUpActions(){
        //Calling Slider
        setSlider()
        
        //Setting status bar none
         self.modalPresentationCapturesStatusBarAppearance = true
        
        //Collectionview delegate
        offersCollectionView.delegate = self
        offersCollectionView.dataSource = self
        
        //Register collectionview cell
        Core.shared.registerCellCollection(at: offersCollectionView, named: Constants.offersCell)
    }
    
    private func gettingData(){}
    
    //-Location from places
    //--Open Waze
    @IBAction func openWaze(_ sender: UIButton) {
        guard let lat = commerces?.lat, let lon = commerces?.lon else {return}
        
        if let addressUrl = URL(string: "waze://?ll=\(lat),\(lon)&navigate=yes"),
            UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
            
            UIApplication.shared.open(addressUrl, options: [:], completionHandler: nil)
        }
        else {
            
            UIApplication.shared.open(URL(string: "https://www.waze.com/location?ll=\(lat),\(lon)&navigate=yes")!, options: [:], completionHandler: nil)
           
        }
        
    }
    //--Open Google Maps
    @IBAction func openGoogleMap(_ sender: UIButton) {
        guard let lat = commerces?.lat, let lon = commerces?.lon else {return}
        
        if let addressUrl = URL(string: "comgooglemaps://?saddr=&daddr=\(lat),\(lon)"), UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) && UIApplication.shared.canOpenURL(addressUrl)  {
            
            UIApplication.shared.open(addressUrl, options: [:], completionHandler: nil)
        }
        else if let webUrl = URL(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(lon)") {
            UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
        }
    }
        
    
    //-Social Networks
    //--Open Facebook
    @IBAction func openFacebook(_ sender: UIButton) {
        
        if let url = URL(string: "fb://profile/100008162417075") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            } else {
                
               
                if let webUrl = URL(string: "https://www.facebook.com/profile.php?id=100008162417075") {
                    UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    //--Open Instagram
    @IBAction func openInstagram(_ sender: UIButton) {
        //guard let commerce = commerces. else{return}
        let instagramHooks = "instagram://user?username=alexgonzcs"
        let instagramUrl = URL(string: instagramHooks)
        
        guard let webUrl = instagramUrl else{ return}
        if UIApplication.shared.canOpenURL(webUrl) {
            UIApplication.shared.open(instagramUrl!)
        } else {
            //redirect to safari because the user doesn't have Instagram
            
            if let webUrl = URL(string: "https://www.instagram.com/alexgonzcs/") {
                UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
            }
        }
        
    }
    
    //-Open dialer
    @IBAction func openDialer(_ sender: UIButton) {
        guard let tel = commerces?.phone else{return}
        
        if let url = URL(string: "tel://\(tel)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    
    
    //Open comments
    @IBAction func openComments(_ sender: UIButton) {
        self.performSegue(withIdentifier: "DetailsToCommentsSegue", sender: nil)
    }
    
    //Dimissing our Controller
    @IBAction func closeDetails(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //Setting slider features
    func setSlider(){
        slideshow.addSubview(maskingUIView)
        maskingUIView.isUserInteractionEnabled = false
        slideshow.backgroundColor = UIColor.white
        slideshow.pageControlPosition = PageControlPosition.insideScrollView
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideshow.clipsToBounds = true
        slideshow.backgroundColor = HexColor(Colors.mainColor)
        slideshow.slideshowInterval = 4.0
        slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
        slideshow.pageControlPosition = PageControlPosition.insideScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = .white
        slideshow.pageControl.pageIndicatorTintColor = HexColor("#5ABFCC")
        
        guard let commerce = commerces, let commerceImage = commerces?.image else{
            return
        }
        
        guard let commerceImages = commerce.gallery else{
            print("gallery error")
            return
        }
        
        if commerceImages.count > 0{
            for commerce in commerceImages{
                print(commerce)
                images.append(KingfisherSource(urlString: commerce)!)
            }
        }
        
        imagePlaceHolder = [ImageSource(image: UIImage(named: "EmptyStateImage")!)]
        print("Count\(commerceImages.count)")
        if commerceImages.count > 0{
            slideshow.setImageInputs(images)
        }else{
            slideshow.setImageInputs(imagePlaceHolder)
        }
        
        //Tap on slider
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        slideshow.addGestureRecognizer(recognizer)
    }
    
    //Hidding status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    // MARK: - Objective C
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
}

extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    
    
}











