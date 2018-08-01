//
//  WebPageController.swift
//  MyShot
//
//  Created by Administrador on 13/06/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView

class WebPageController: UIViewController,WKNavigationDelegate, NVActivityIndicatorViewable{
    // MARK: - Let-Var
    let size = CGSize(width: 30, height: 30)
    
    // MARK: - Outlets
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
       
    }
    
    // MARK: - SetUps / Funcs
    func setUpUI(){}
    func setUpActions(){
        //Setting webview
        webView.navigationDelegate = self
        
        
        guard let url = URL(string: Constants.webSite) else { return  }
        webView.load(URLRequest(url: url))
        
        
    }
    
    @IBAction func backController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        customLoading(at: self)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.stopAnimating()
        Core.shared.alert(message: "No se pudo cargar el sitio web", title: "Algo sucedio mal", at: self)
    }
    
    
    
    //Custom loading
    func customLoading(at:WebPageController){
        at.startAnimating(size, message: "...", type: NVActivityIndicatorType.orbit)
    }
    
}
