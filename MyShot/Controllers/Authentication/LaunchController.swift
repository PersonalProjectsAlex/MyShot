//
//  LaunchController.swift
//  MyShot
//
//  Created by Administrador on 28/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import UIKit
import Lottie

class LaunchController: UIViewController {
    // MARK: - Let-Var
    var animationView: LOTAnimationView = LOTAnimationView(name: "logo")
    let defaults = UserDefaults.standard
    //MARK:- LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Lottie
        
        animationView.frame = view.bounds
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        
        animationView.play()
        animationView.loopAnimation = true
        
        self.view.addSubview(animationView)
        
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.splashTimeOut(sender:)), userInfo: nil, repeats: false)
        
    }
    
    @objc func splashTimeOut(sender : Timer){
        //LaunchToSignInController
        //LaunchToMenuController
        
        guard let accepted = defaults.string(forKey: "logged") else {
            performSegue(withIdentifier: "LaunchToSignInController", sender: self)
            return
        }
        
        performSegue(withIdentifier: "LaunchToMenuController", sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
