//
//  ProfileController.swift
//  MyShot
//
//  Created by Administrador on 4/06/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView
import FirebaseStorage
import Firebase

class ProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,NVActivityIndicatorViewable {
    // MARK: - Let-Var
    var saveImage = String()
    let storage = FIRStorage.storage().reference()
    let size = CGSize(width: 30, height: 30)
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.clipsToBounds = true
        profileImageView.cornerRadiusView = min(profileImageView.frame.width/2 , profileImageView.frame.height/2)
        
    }
    
   
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
    
    // MARK: - SetUps / Funcs
    func setUpUI(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       // blurImageView.addSubview(blurEffectView)
        
    }
    
    func setUpActions(){
        guard let urlImage =  URL(string: UserSingleton.shared.loggedUser(key:
            DefaultKeys.userPhoto)) else {return}
        self.profileImageView.sd_setImage(with:  urlImage, placeholderImage: #imageLiteral(resourceName: "EmptyStateImage"))
        
        nameLabel.text = "¿Qué hay? " + UserSingleton.shared.loggedUser(key: DefaultKeys.userName)
        
    }
    
    private func gettingData(){}
    
    //Change photo
    @IBAction func changePhoto(_ sender: UIButton) {
        showInputDialog()
    }
    
    
    //Alert option for changing photo
    func showInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Cambiar", message: "¿Deseas cambiar tu fotografía?", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Cambiar", style: .default) { (_) in
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
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
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
            profileImageView.image = selectedImage
        
           changeImage(id:UserSingleton.shared.loggedUser(key: DefaultKeys.userID))
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Storage and change image
    func changeImage(id:String){
        
        let imageName = "profile\(id).png"
        self.customLoading(at: self)
        let storedImage = storage.child("profile_images").child(imageName)
        if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!)
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
                        let params:Params = ["id": UserSingleton.shared.loggedUser(key: DefaultKeys.userID), "picture": self.saveImage]
                        UserSingleton.shared.setNewPhoto(self.saveImage)
                        UsersManager().updateProfile(params: params, completionHandler: {
                            updatephoto in
                            
                            self.stopAnimating()
                        })
                        
                        
                        
                        
                    }
                })
                
            })
        }
    }
    
    //Custom loading
    func customLoading(at:ProfileController){
        at.startAnimating(size, message: "...", type: NVActivityIndicatorType.orbit)
    }
    
}
