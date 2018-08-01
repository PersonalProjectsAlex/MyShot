//
//  CommerceCommentTableController.swift
//  MyShot
//
//  Created by Administrador on 27/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import UIKit
import Hero
import NVActivityIndicatorView


class CommerceCommentTableController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable  {

    // MARK: - Let-Var
    var comments = [Comments]()
    var commerces: Commerces?
    let size = CGSize(width: 30, height: 30)
    
    
    // MARK: - Outlets
    @IBOutlet weak var commentTextfield: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentButton: UIButton!
    
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        gettingData()
    }
    
    // MARK: - SetUps / Funcs
    
    func setUpUI(){
        profileImageView.roundedImage()
        guard let urlImage =  URL(string: UserSingleton.shared.loggedUser(key:
            DefaultKeys.userPhoto)) else {return}
        profileImageView.sd_setImage(with:  urlImage, placeholderImage: #imageLiteral(resourceName: "logoicon"))
        
    }
    
    func setUpActions(){
        commentTextfield.becomeFirstResponder()
        self.hero.isEnabled = true
        self.hero.modalAnimationType = .cover(direction: .up)
        tableView.delegate = self
        tableView.dataSource = self
        
        commentButton.isEnabled = false
        commentTextfield.addTarget(self, action: #selector(textFieldsIsNotEmpty),
                                   for: .editingChanged)
        //Registering comment cell
        Core.shared.registerCell(at: tableView, named: Constants.commentsCell, withIdentifier: Constants.commentsCell)
    }
    
    private func gettingData(){
        tableView.reloadData()
        customLoading(at: self)
        guard let idCommerce = commerces?.id else {return}
        CommentsManager().getCommments(idcommerce: idCommerce) {
            prueba in
            
            guard let comments = prueba?.comments, comments.count > 0 else{
                self.stopAnimating()
                return
            }
            self.stopAnimating()
            self.comments = comments
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func closeComments(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func commentAction(_ sender: UIButton) {
        customLoading(at: self)
        
        
        guard let comment = self.commentTextfield.text, !comment.isEmpty, comment.count > 3 else{
            self.stopAnimating()
            //Core.shared.playSound()
            return
        }
         guard let idCommerce = commerces?.id else {return}
        let param:Params = ["userId": UserSingleton.shared.loggedUser(key: DefaultKeys.userID), "comment": comment]
        CommentsManager().setCommments(idcommerce: idCommerce, params: param) {
            setcomment in
            guard let msg = setcomment?.msg else{return}
            
            if msg == "Comment Added!"{
                self.gettingData()
                self.stopAnimating()
                self.commentTextfield.text = ""
            }else{
                Core.shared.alert(message: "Sucedio algo mal:", title: "El comentario no pudo ser enviado", at: self)
            }
            
        }
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return  1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.comments.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.commentsCell, for: indexPath) as? CommentsCell else { return UITableViewCell() }
        
        cell.setComments = comments[indexPath.row]
        
        return cell
    }
    
    //height for rows
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Custom loading
    func customLoading(at:CommerceCommentTableController){
        at.startAnimating(size, message: "...", type: NVActivityIndicatorType.orbit)
    }
   
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        
        //sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        guard let comment = self.commentTextfield.text, !comment.isEmpty, comment.count > 3 else
        {
            self.commentButton.isEnabled = false
            return
        }
        
        if let j = self.commentTextfield.text, j == "@"  {
            print("Yeiii @ ")
        }
        
        
        if (self.commentTextfield.text?.range(of: "@")) != nil {
            
            ///guard let h = self.comments. else{return}
            if self.comments.count > 0{
                for i in self.comments{
                    if let s = i.user?.name{
                        print(s)
                    }
                }
            }
        }
        // enable okButton if all conditions are met
        commentButton.isEnabled = true
    }

}
