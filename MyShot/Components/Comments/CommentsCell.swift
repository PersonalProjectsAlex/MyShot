//
//  CommentsCell.swift
//  MyShot
//
//  Created by Administrador on 28/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import UIKit

class CommentsCell: UITableViewCell {

    var setComments: Comments?{
        didSet {
            setupCell()
        }
    }
    
    
    // MARK: - Let-Var
    var menu: Offers?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    // MARK: SETUPS/LOADERS
    
    func setupCell() {
        
        guard let data = setComments else{
            print("Issue in dataResponse")
            return
        }
        nameLabel.text = data.user?.name
        commentLabel.text = data.comment
        profileImageView.roundedImage()
        
        if let image = data.user?.picture{
            profileImageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "logoicon"))
        }
        
        
    }
    
   
    
}
