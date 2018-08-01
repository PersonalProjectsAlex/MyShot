//
//  SignInController.swift
//  MyShot
//
//  Created by Alexander on 17/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import Google
import NVActivityIndicatorView
import LTMorphingLabel

class SignInController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, NVActivityIndicatorViewable, LTMorphingLabelDelegate{
    // MARK: - Let-Var
    
    
    
    
        //--Facebook
        var facebookUser: FacebookUser?
        let loginManager = LoginManager()
        let readPermissions: [ReadPermission] = [ .publicProfile, .email, .userFriends]
        //--Facebook
        var googleUser = [GoogleUser]()
    let defaults = UserDefaults.standard
    let size = CGSize(width: 30, height: 30)
    fileprivate var i = -1
    
    var isTextOne = true
    var textOne: String = "¿Posees cuenta MyShot?"
    var textTwo: String = "Disfruta con nosotros 😉"
    
    // MARK: - Outlets
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var changeLabel: LTMorphingLabel!
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up general actions/delegates/Core
        setUpActions()
        changeLabel.delegate = self
        changeLabel.morphingDuration = 1
        
        
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(toggleText), userInfo: nil, repeats: true)
    
        UserSingleton.shared.facebookSignOut()
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().disconnect()
        
        
    }
    
    
    @objc func toggleText() {
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        weak.changeLabel.text = isTextOne ? textTwo:textOne
        isTextOne = !isTextOne
    }
    
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignInToSignUpController" {
            
            
            let nav = segue.destination as! UINavigationController
            let signupController = nav.topViewController as! SignUpController
            signupController.googleUser = googleUser
        }
    }
    
    // MARK: - SetUps / Funcs
    
    func setUpUI(){}
    
    func setUpActions(){
        //Getting updated From Facebook Token
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
    }
    
    
    //Parsing Data
    private func gettingData(username:String, password: String){
        
        
        self.customLoading(at: self)
      
        
        let params: Params = ["username":username,"password":password]
        
        UsersManager().Login(params: params) {
            base in
            print(base)
            guard let msg = base?.msg else{
                weak var weakSelf = self
                guard let weak = weakSelf else{return}
                guard let photo = base?.user?.picture, let userName = base?.user?.name, let userID = base?.user?.id else{return}
                
                weak.stopAnimating()
                UserSingleton.shared.keepLogged("logged")
                print(userID)
                UserSingleton.shared.setCurrentUser(userName, photo, userID)
                
                weak.performSegue(withIdentifier: "SignInToSideController ", sender: nil)
                return
            }
            
            let save = msg
            if save == "Error: User not found" || save == "Error: Invalid password!"{
                self.stopAnimating()
                Core.shared.alert(message: "Por favor ingrese las credenciales correctas", title: "Sucedio algo mal:", at: self)
            }
            
            
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
    //username login process
    
    @IBAction func SigninByUser(_ sender: UIButton) {
        guard let user = usernameTextfield.text, !user.isEmpty else {
            Core.shared.alert(message: "Debes ingresar un nombre de usuario", title: "Sucedio algo mal:", at: self)
            return
        }
        guard let password = passwordTextfield.text, !password.isEmpty else {
            Core.shared.alert(message: "Debes ingresar una contraseña", title: "Sucedio algo mal:", at: self)
            return
        }
        
        gettingData(username: user, password: password)
        
    }
    
    
    //Sign in Facebook actions and getting Graph data
    @IBAction func signinFacebook(_ sender: UIButton) {
        weak var weakSelf = self
        loginManager.logIn(readPermissions: readPermissions, viewController: self) {
            loginResult in
            
            guard case .success = loginResult else { print("Error")
                return }
            
            guard let accessToken = AccessToken.current else { return }
            
            let facebookAPIManager = FacebookAPIManager(accessToken: accessToken)
        
            facebookAPIManager.requestFacebookUser {
                facebookUser in
                guard let weak = weakSelf else{return}
                weak.facebookUser = facebookUser
                if let token = accessToken.userId{
                    let params:Params = ["fb_id": token]
                    self.customLoading(at: self)
                    UsersManager().CheckSocial(params: params, completionHandler: {
                        validate in
                        guard let newUser = validate?.newUser, newUser == true else{
                            weak var weakSelf = self
                            guard let weak = weakSelf else{return}
                           
                            weak.stopAnimating()
                            weak.defaults.set("logged", forKey: "logged")
                            guard let photo = validate?.user?.picture, let userName = validate?.user?.name, let userID = validate?.user?.id else{return}
                            UserSingleton.shared.setCurrentUser(userName, photo, userID)
                            UserSingleton.shared.facebookSignOut()
                            weak.performSegue(withIdentifier: "SignInToSideController ", sender: nil)
                            weak.stopAnimating()
                            return
                        }
                        self.stopAnimating()
                        
                        weak.performSegue(withIdentifier: "SignInToSignUpController", sender: self)
                    })
                }
                
               
            }
        }
    }
    
    @IBAction func btnGoogleLoginOnClick(_ sender: UIButton)
    {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        weak var weakSelf = self
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let weak = weakSelf else{return}
        //guard let authentication = user.authentication else {return}
        
        guard let userName = user.profile.name, let gmail = user.profile.email, let token = user.userID  else {return}
        let photo = user.profile.imageURL(withDimension: 400).absoluteString
        var items = userName.components(separatedBy: " ")
        //take one array for splitting the string
        let fname = items[0]
        
        //Validation if gmail already exist
        let params:Params = ["gmail": gmail]
        self.customLoading(at: self)
        UsersManager().CheckSocial(params: params, completionHandler: {
            validate in
            guard let newUser = validate?.newUser, newUser == true else{
                weak var weakSelf = self
                guard let weak = weakSelf else{return}
                
                weak.stopAnimating()
                weak.defaults.set("logged", forKey: "logged")
                
                UserSingleton.shared.facebookSignOut()
                weak.performSegue(withIdentifier: "SignInToSideController ", sender: nil)
                weak.stopAnimating()
                return
            }
            
            self.stopAnimating()
            weak.googleUser.append(GoogleUser(userName: fname, email: gmail, googletoken: token, photo: photo))
            weak.performSegue(withIdentifier: "SignInToSignUpController", sender: self)
        })
       
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {}
   
    func parseDuration(timeString: String) -> TimeInterval {
        
        var interval: Double = 0
        let parts = timeString.components(separatedBy: ":")
        
        guard !timeString.isEmpty else { return 0 }
        
        for (index, part) in parts.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }
        
        return interval
    }
    
    //Custom loading
    func customLoading(at:SignInController){
        at.startAnimating(size, message: "...", type: NVActivityIndicatorType.orbit)
    }
}

extension SignInController {
    
    func morphingDidStart(_ label: LTMorphingLabel) {
        
    }
    
    func morphingDidComplete(_ label: LTMorphingLabel) {
        
    }
    
    func morphingOnProgress(_ label: LTMorphingLabel, progress: Float) {
        
    }
    
}

