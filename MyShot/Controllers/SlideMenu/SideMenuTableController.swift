import Foundation
import SideMenu
import HexColors
import Alamofire
import SDWebImage

class SideMenuTableController: UITableViewController {
    
    
    // MARK: - Let-Var
    var tableFooterView: UIView?
    let defaults = UserDefaults.standard
    
    // MARK: - Outlets
    @IBOutlet weak var profileImageview: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var firstselectedView: UIView!
     @IBOutlet weak var secondselectedView: UIView!
    @IBOutlet weak var thirdselectedView: UIView!
    @IBOutlet weak var forthselectedView: UIView!
    @IBOutlet weak var fifthselectedView: UIView!
    
    // MARK: - LifeCycles
    override func viewDidLayoutSubviews() {
        setUpUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // setting up UI elements to be used through the code
        
        guard let urlImage =  URL(string: UserSingleton.shared.loggedUser(key:
            DefaultKeys.userPhoto)) else {return}
        self.profileImageview.sd_setImage(with:  urlImage, placeholderImage: #imageLiteral(resourceName: "EmptyStateImage"))
        userNameLabel.text =  "\(UserSingleton.shared.loggedUser(key: DefaultKeys.userName))\("😎")"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUPActions()
    }
    
    // MARK: - SetUps / Funcs
    
    func setUpUI(){
        
        //NavigationController
        Core.shared.generalNavigation(at: self)
        
        //Circle imageview
        profileImageview.roundedImage()
        
        // Removing extra cells
        self.tableView.separatorStyle = .none
        
        //Imagebackground
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background2"))
        
        //Setting menu
        guard let accepted = defaults.string(forKey: DefaultKeys.cellMenu) else {return}
        switch accepted {
        case "2":
            firstselectedView.isHidden = false
            secondselectedView.isHidden = true
            thirdselectedView.isHidden = true
            forthselectedView.isHidden = true
            fifthselectedView.isHidden = true
        case "3":
            firstselectedView.isHidden = true
            secondselectedView.isHidden = false
            thirdselectedView.isHidden = true
            forthselectedView.isHidden = true
            fifthselectedView.isHidden = true
        case "4":
            firstselectedView.isHidden = true
            secondselectedView.isHidden = true
            thirdselectedView.isHidden = false
            forthselectedView.isHidden = true
            fifthselectedView.isHidden = true
        
            
        default:
            print("Error")
            firstselectedView.isHidden = true
            secondselectedView.isHidden = true
            thirdselectedView.isHidden = true
            forthselectedView.isHidden = true
            fifthselectedView.isHidden = true
        }
        
    }
    
    
    func setUPActions(){
        // Refresh cell blur effect in case it changed
        tableView.reloadData()
        guard SideMenuManager.default.menuBlurEffectStyle == nil else {
            return
        }
        gettingData()
    }
    
    //Parsing Data
    private func gettingData(){
        
    }
    
    //Sign Out
    
    @IBAction func singOut(_ sender: UIButton) {
        UserSingleton.shared.resetUser()
        UserSingleton.shared.facebookSignOut()
        performSegue(withIdentifier: "SignOutToAuth", sender: nil)
        Core.shared.logoutNavigation(at:self)
        
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! UITableViewVibrantCell
        cell.blurEffectStyle = SideMenuManager.default.menuBlurEffectStyle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //State selected
        defaults.removeObject(forKey: "cellMenu")
        switch indexPath.row {
        case 0:
            print("0")
        
        case 2:
           
           defaults.set("2", forKey: "cellMenu")
            
        case 3:
            defaults.set("3", forKey: "cellMenu")
        case 4:
            
            defaults.set("4", forKey: "cellMenu")
        default:
            print("Error")
            
        }
    }
    
    func showSelectedState(selected: UIView, off: [UIView]){
        selected.isHidden = false
        for views in off{
            views.isHidden = true
        }
        
    }
    
    
    
}
