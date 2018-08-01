//
//  MainMenuController.swift
//  Variedades Genesis
//
//  Created by Administrador on 5/05/18.
//  Copyright © 2018 Genesis. All rights reserved.
//

import UIKit
import SideMenu

class MainMenuController: UIViewController {
    // MARK: - Let-Var
    var isVertical : Bool = false
    // MARK: - Outlets
    @IBOutlet weak var showMenuButton: UIBarButtonItem!
 
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up general actions/delegates/Core
        setUPActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
        
    
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
    }
 
    
    // MARK: - SetUps / Funcs
    
    
    func setUpUI(){
        //Setting navigation bar
        Core.shared.generalNavigation(at: self)
        
      
    }
    
    func setUPActions(){
        
        //Setting SideMenu
        setupSideMenu()
        
    }
    
    @IBAction func rotateIconBarButton(_ sender: UIBarButtonItem) {
       
    }
    
    fileprivate func setupSideMenu() {
        
        // Defining menus
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        // Enable gestures
        if let navigation = self.navigationController {
            SideMenuManager.default.menuAddPanGestureToPresent(toView: navigation.navigationBar)
            SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: navigation.view)
        }
        
    }
    
}
