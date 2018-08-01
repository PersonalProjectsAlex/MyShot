//
//  SignUpController.swift
//  MyShot
//
//  Created by Administrador on 30/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import Google

class SignUpController: UIViewController{
    // MARK: - Let-Var
        //--Facebook
        var facebookUser: FacebookUser?
        //-- Google
        var googleUser = [GoogleUser]()
    var registerUser = [RegisterUser]()
    var saveGooglePhoto:String?
    
    // MARK: - Outlets
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var replyPasswordTextfield: UITextField!
    
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
        
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpToImageController" {
            
            let detailController = segue.destination as! ImageSignUpController
            detailController.registerUser = registerUser
            detailController.saveGooglePhoto = saveGooglePhoto
            
        }
    }
    
    // MARK: - SetUps / Funcs
    func setUpUI(){
        Core.shared.generalNavigation(at: self)
    }
    
    
    func setUpActions(){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        if let accessToken = AccessToken.current{
            let facebookAPIManager = FacebookAPIManager(accessToken: accessToken)
        
            facebookAPIManager.requestFacebookUser {
                facebookUser in
                self.facebookUser = facebookUser
                
                if let userID = accessToken.userId{
                    let a = "http://graph.facebook.com/\(userID)/picture?type=large"
                }

                if let firstName = facebookUser.firstName, let email = facebookUser.email {
                    weak.emailTextfield.text = email
                    weak.welcomeLabel.text = "Bienvenido \(firstName), registremos tu usuario"
                }else{
                    weak.welcomeLabel.text = "Bienvenido, ahora registremos tu usuario"
                }
                
                
            }
        }
        
        if googleUser.count > 0{
            for user in googleUser{
                print(user.googletoken)
                weak var weakSelf = self
                guard let weak = weakSelf else{return}
                var items = user.userName.components(separatedBy: " ")
                //take one array for splitting the string
                let fname = items[0]
                weak.saveGooglePhoto = user.photo
                weak.welcomeLabel.text = "Bienvenido \(fname), registremos tu usuario"
                weak.emailTextfield.text = user.email
            }
        }
        
        
    }
    
    //SingUp Action
    @IBAction func signUp(_ sender: UIButton) {
        guard let username = userNameTextField.text, let password = passwordTextfield.text, let replypassword = replyPasswordTextfield.text, !username.isEmpty, !password.isEmpty, !replypassword.isEmpty else{
            Core.shared.alert(message: "Favor completar los campos necesarios", title: "Sucedio algo:", at: self)
            return
        }
        
        guard let userLenght = userNameTextField.text, userLenght.count > 3 else{
            Core.shared.alert(message: "Nombre de usuario debe poseer al menos 4 caracteres", title: "Sucedio algo:", at: self)
            return
        }
        

        
        if password == replypassword{
            registerUser.append(RegisterUser(userName: username, email: emailTextfield.text ?? "", password: password))
            
            performSegue(withIdentifier: "SignUpToImageController", sender: nil)
        }else{
            Core.shared.alert(message: "Las contraseñas deben coincidir", title: "Sucedio algo:", at: self)
        }
        
        
        
    }
    
    
    private func gettingData(){}
    
    // MARK: - Objective C

}
