//
//  ImageSignUpController.swift
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
import SDWebImage
import NVActivityIndicatorView
import FirebaseStorage
import Firebase

class ImageSignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,NVActivityIndicatorViewable {

    // MARK: - Let-Var
        //--Facebook
        var facebookUser: FacebookUser?
    
    let defaults = UserDefaults.standard
    let size = CGSize(width: 30, height: 30)
    var registerUser = [RegisterUser]()
    var saveImage = String()
    let storage = FIRStorage.storage().reference()
    var saveGooglePhoto:String?
    
    // MARK: - Outlets
    @IBOutlet weak var userImageView: UIImageView!
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
        
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
    
    // MARK: - SetUps / Funcs
    
    func setUpUI(){
       
    }
    
    func setUpActions(){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        if let accessToken = AccessToken.current, let token = accessToken.userId{
            let url = "http://graph.facebook.com/\(token)/picture?width=9999"
            weak.saveImage =  url
            guard let profileImage = URL(string: url) else{return}
            weak.userImageView.sd_setImage(with: profileImage, placeholderImage: #imageLiteral(resourceName: "logoicon"))
        }
        
        if let googlePhoto = saveGooglePhoto{
            guard let profileImage = URL(string: googlePhoto) else{return}
            weak.userImageView.sd_setImage(with: profileImage, placeholderImage: #imageLiteral(resourceName: "logoicon"))
        }
        
    }
    
    @IBAction func changeImage(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camara", style: .default, handler: {
            action in
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Seleccionar fotografia", style: .default, handler: {
            action in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //setting image selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
            userImageView.image = selectedImage
            guard let accessToken = AccessToken.current?.userId else { return }
            changeImage(id:accessToken)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Check registering process
    @IBAction func finishSignUpProcess(_ sender: UIButton) {
        guard let accessToken = AccessToken.current?.userId else { return }
        for i in registerUser{
            guard let userName = i.userName, let password = i.password else {return}
             self.gettingDataAfacebook(username: userName, password: password, fb_id: accessToken, name: "Alex", picture: self.saveImage)
        }
    }
    
    //Parsing Data
    private func gettingDataAfacebook(username:String, password: String, fb_id: String, name: String, picture: String){
        
        self.customLoading(at: self)
        
        let params: Params = ["username":username,"password":password, "fb_id": fb_id, "name": name,"picture":picture]
        
        UsersManager().RegisterFacebook(params: params) { (base) in
            guard let msg = base?.msg else{
                weak var weakSelf = self
                guard let weak = weakSelf else{return}
                guard let photo = base?.user?.picture, let userName = base?.user?.name, let userID = base?.user?.id else{return}
                weak.stopAnimating()
                UserSingleton.shared.keepLogged("logged")
                UserSingleton.shared.setCurrentUser(userName, photo, userID)
                
                UserSingleton.shared.facebookSignOut()
                weak.performSegue(withIdentifier: "SignInToMenuController", sender: nil)
                return
            }
            
            let save = msg
            if save == "User not found" || save == "username already used!"{
                self.stopAnimating()
                Core.shared.alert(message: "Por favor ingrese las credenciales correctas", title: "Sucedio algo mal:", at: self)
            }
            
            
        }
    }
    
    
    //Storage and change image
    func changeImage(id:String){
       
        let imageName = "profile\(id).png"
        self.customLoading(at: self)
        let storedImage = storage.child("profile_images").child(imageName)
        if let uploadData = UIImagePNGRepresentation(self.userImageView.image!)
        {
            storedImage.put(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error!)
                    self.stopAnimating()
                    return
                }
                storedImage.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error!)
                        self.stopAnimating()
                        
                        return
                    }else{
                        
                        guard let photo = metadata?.downloadURL() else {
                            Core.shared.alert(message: "Sucedio un error con esta imagen intente de nuevo", title: "Sucedio algo:", at: self)
                            self.stopAnimating()
                            return
                        }
                        
                        print(photo.description)
                        self.saveImage = photo.description
                        self.stopAnimating()
                        
                        
                    }
                })
                
            })
        }
    }
    
    
    
    
    
    
    //Closing a session
    
    //Custom loading
    func customLoading(at:ImageSignUpController){
        at.startAnimating(size, message: "...", type: NVActivityIndicatorType.orbit)
    }

}
