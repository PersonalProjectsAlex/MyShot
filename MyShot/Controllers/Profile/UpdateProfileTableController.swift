//
//  UpdateProfileTableController.swift
//  MyShot
//
//  Created by Mac on 14/6/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import UIKit

class UpdateProfileTableController: UITableViewController {
    // MARK: - Let-Var
    
    // MARK: - Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var replypasswordTextField: UITextField!
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }

    // MARK: - Table view data source

    @IBAction func saveChanges(_ sender: UIButton) {
        
        guard let username = usernameTextField.text, let password = passwordTextField.text, let replypassword = replypasswordTextField.text, !username.isEmpty, !password.isEmpty, !replypassword.isEmpty else{
            Core.shared.alert(message: "Favor completar los campos necesarios", title: "Sucedio algo:", at: self)
            return
        }
        
        guard let userLenght = usernameTextField.text, userLenght.count > 3 else{
            Core.shared.alert(message: "Nombre de usuario debe poseer al menos 4 caracteres", title: "Sucedio algo:", at: self)
            return
        }
        
        if password == replypassword{
            let params: Params = ["id": UserSingleton.shared.loggedUser(key: DefaultKeys.userID),"username":username, "password":password]
            UsersManager().updateProfile(params: params) {
                update in
                guard let user = update?.user?.username else {return}
                UserSingleton.shared.setUsername(user)
            }
            
        }else{
            Core.shared.alert(message: "Las contraseñas deben coincidir", title: "Sucedio algo:", at: self)
        }
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
