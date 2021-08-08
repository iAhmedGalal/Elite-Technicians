//
//  SideMenuVC.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//


import UIKit

class SideMenuVC: UITableViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userProfileBtn: UIButton!
    @IBOutlet weak var languageBtn: UIButton!
    
    @IBOutlet weak var ordersLabel: UILabel!

    
    @IBOutlet weak var userImage: CircleImage!
    
    @IBOutlet weak var notificationsView: UIView!
    @IBOutlet weak var notificationsLabel: UILabel!
    
    @IBOutlet weak var ordersView: UIView!
    @IBOutlet weak var ordersTitleLabel: UILabel!
    
    var notificationCount: String = "0"
    
    var ordersCount: String = "0"
    
    var token: String = ""
    var userId: String = ""
    var name: String = ""
    var image: String = ""
    var type: String = ""
    var verified: String = ""

    override func viewWillAppear(_ animated: Bool) {
        getUserData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserData()
        
        notificationCount = Helper.getUserDefault(key: Constants.userDefault.notificationsCount) as! String
        notificationsLabel.text = notificationCount
        
        ordersCount = Helper.getUserDefault(key: Constants.userDefault.ordersCount) as! String
        ordersLabel.text = ordersCount
        
        if notificationCount == "0" || notificationCount == "" {
            notificationsView.isHidden = true
        }
        
        if ordersCount == "0" || ordersCount == "" {
            ordersView.isHidden = true
        }
        
        
        if token == "" {
            userName.text = "Welcome".localiz()
            loginBtn.isHidden = false
            userProfileBtn.isHidden = true
            
        }else {
            userName.text = name
            loginBtn.isHidden = true
            userProfileBtn.isHidden = false
            
            userImage.sd_setImage(with: URL(string: image))
        }
        
        if type == "provider" {
            ordersView.isHidden = false
            ordersTitleLabel.text = "Orders".localiz()
        }else {
            ordersView.isHidden = true
            ordersTitleLabel.text = "My Orders".localiz()
        }

        if LanguageManger.shared.currentLanguage == .ar {
            languageBtn.setTitle("EN", for: .normal)
        }else {
            languageBtn.setTitle("AR", for: .normal)
        }
        
    }
    
    func getUserData() {
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        name = userDate?.name ?? ""
        image = userDate?.image_url ?? ""
        type = userDate?.type ?? ""
        verified = userDate?.verified ?? ""
    }
    
    @IBAction func loginBtn_tapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: Constants.storyBoard.authentication, bundle: nil)
        let editVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        editVC.title = "Login".localiz()
        //            editVC.fromRegistration = false
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    
    @IBAction func userProfileBtn_tapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: Constants.storyBoard.authentication, bundle: nil)
        let editVC = storyBoard.instantiateViewController(withIdentifier: "EditVC") as! EditVC
        editVC.title = "Profile".localiz()
        //            editVC.fromRegistration = false
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @IBAction func languageBtn_tapped(_ sender: Any) {
        if LanguageManger.shared.currentLanguage == .ar {
            LanguageManger.shared.setLanguage(language: .en)
        }else {
            LanguageManger.shared.setLanguage(language: .ar)
        }
        
        print("Language", LanguageManger.shared.currentLanguage)
        
        UIApplication.shared.windows[0].rootViewController = UIStoryboard(
            name:Constants.storyBoard.main,
            bundle: nil
        ).instantiateViewController(withIdentifier: "mainNC")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        
        switch indexPath.row {
            
        case 0:
            height = 120
            
        case 1,3,4,6,7,8,14:
            if token == "" {
                height = 0
            }else {
                height = 50
            }
            
        case 2:
            if token == "" {
                height = 0
            }else {
                if type == "provider" {
                    height = 50
                }else {
                    height = 0
                }
            }
            
        case 5:
            if token == "" {
                height = 0
            }else {
                if verified == "yes" {
                    height = 0
                }else {
                    height = 50
                }
            }
            
        case 9,10:
            if token == "" {
                height = 0
            }else {
                if type == "provider" {
                    height = 0
                }else {
                    height = 0
                }
            }
            
        default:
            height = 50
        }
        
        return height
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print ("Index", indexPath.row)
        
        if indexPath.row == 1 { //orders
            if type == "provider" {
                let storyBoard = UIStoryboard(name: Constants.storyBoard.provider, bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ProviderOrdersVC") as! ProviderOrdersVC
                vc.title = "Orders".localiz()
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else {
                ordersView.isHidden = true

                let storyBoard = UIStoryboard(name: Constants.storyBoard.user, bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "MyOrdersVC") as! MyOrdersVC
                vc.title = "My Orders".localiz()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        else if indexPath.row == 2 { // my services
            let storyBoard = UIStoryboard(name: Constants.storyBoard.provider, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProviderServicesVC") as! ProviderServicesVC
            vc.title = "My services".localiz()
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
            
        else if indexPath.row == 3 { // messages
            let storyBoard = UIStoryboard(name: Constants.storyBoard.user, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "MessagesVC") as! MessagesVC
            vc.title = "Messages".localiz()
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if indexPath.row == 4 { // Notifications
            let storyBoard = UIStoryboard(name: Constants.storyBoard.user, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
            vc.title = "Notifications".localiz()
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if indexPath.row == 5 { // request
            let storyBoard = UIStoryboard(name: Constants.storyBoard.main, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "VerificationRequestVC") as! VerificationRequestVC
            vc.title = "Verification Request".localiz()
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if indexPath.row == 6 { // statement
            if type == "provider" {
                let storyBoard = UIStoryboard(name: Constants.storyBoard.provider, bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ProviderStatementVC") as! ProviderStatementVC
                vc.title = "Account Statement".localiz()
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                let storyBoard = UIStoryboard(name: Constants.storyBoard.user, bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "AccountStatementVC") as! AccountStatementVC
                vc.title = "Account Statement".localiz()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
            
        else if indexPath.row == 7 { // Favourites
            let storyBoard = UIStoryboard(name: Constants.storyBoard.user, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesVC
            vc.title = "Favourites".localiz()
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if indexPath.row == 8 { // locations
            let storyBoard = UIStoryboard(name: Constants.storyBoard.user, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "SavedLocationsVC") as! SavedLocationsVC
            vc.title = "Saved Locations".localiz()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        else if indexPath.row == 9 { // commission
            let storyBoard = UIStoryboard(name: Constants.storyBoard.provider, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ProviderCommissionVC") as! ProviderCommissionVC
            vc.title = "Commission".localiz()
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if indexPath.row == 10 { // discount request
            self.dismiss(animated: true, completion: nil)

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "discountNotification"), object: nil, userInfo: nil)
        }
            
        else if indexPath.row == 11 { // terms
            let storyBoard = UIStoryboard(name: Constants.storyBoard.main, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PagesDetailsVC") as! PagesDetailsVC
            vc.title = "Terms and conditions".localiz()
            vc.pageId = 2
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if indexPath.row == 12 { // About
            let storyBoard = UIStoryboard(name: Constants.storyBoard.main, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PagesDetailsVC") as! PagesDetailsVC
            vc.title = "About us".localiz()
            vc.pageId = 1
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if indexPath.row == 13 { // contactus
            let storyBoard = UIStoryboard(name: Constants.storyBoard.main, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ContactusVC") as! ContactusVC
            vc.title = "Contact us".localiz()
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if indexPath.row == 14 { // logout
            Helper.removeKeyUserDefault(key: Constants.userDefault.userData)
            Helper.removeKeyUserDefault(key: Constants.userDefault.userReservation)

            Helper.goToLoginScreen(controller: self)
        }
    }
    
}
