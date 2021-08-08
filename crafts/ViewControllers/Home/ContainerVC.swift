//
//  ContainerVC.swift
//  crafts
//
//  Created by AL Badr  on 12/28/20.
//

import UIKit
import SideMenu

class ContainerVC: UIViewController {
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var tabsView: UIView!
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var ordersView: UIView!
    @IBOutlet weak var notificationssView: UIView!
    @IBOutlet weak var favouritesView: UIView!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var orderProviderView: UIView!

    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var ordersBtn: UIButton!
    @IBOutlet weak var notificationsBtn: UIButton!
    @IBOutlet weak var favouritesBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var orderProviderBtn: UIButton!
    
    
    @IBOutlet weak var addServiceBtn: GradientButton!
    
    @IBOutlet weak var notificationsCountLabel: UILabel!
    @IBOutlet weak var notificationsCountView: UIView!
    
    var isProfileOpen: Bool = false
    var isOrdersOpen: Bool = false
    var isNotificationsOpen: Bool = false
    var isfavouritesOpen: Bool = false
    var isHomeOpen: Bool = false
    
    var token: String = ""
    var type: String = ""
    var notificationCount: String = "0"

    // MARK: - Declare Viewcontrollers
    private lazy var HomeViewController: HomeVC = {
        let storyboard = UIStoryboard(name: Constants.storyBoard.main, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        return viewController
    }()
    
    private lazy var favouriteVC: FavouritesVC = {
        let storyboard = UIStoryboard(name: Constants.storyBoard.user, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesVC
        return viewController
    }()
    
    private lazy var notificationsVC: NotificationsVC = {
        let storyboard = UIStoryboard(name: Constants.storyBoard.user, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        return viewController
    }()
    
    private lazy var ordersVC: MyOrdersVC = {
        let storyboard = UIStoryboard(name: Constants.storyBoard.user, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "MyOrdersVC") as! MyOrdersVC
        return viewController
    }()
    
    private lazy var providerOrdersVC: ProviderOrdersVC = {
        let storyboard = UIStoryboard(name: Constants.storyBoard.provider, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ProviderOrdersVC") as! ProviderOrdersVC
        return viewController
    }()
    
    private lazy var editVC: EditVC = {
        let storyboard = UIStoryboard(name: Constants.storyBoard.authentication, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "EditVC") as! EditVC
        return viewController
    }()

    override func viewWillAppear(_ animated: Bool) {
        getUserData()
        updateCount()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(GetContainerNotifications), name: NSNotification.Name(rawValue: "ContainerNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GetContainerNotifications), name: NSNotification.Name(rawValue: "discountNotification"), object: nil)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let image : UIImage = UIImage(named: "logoheader")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        addServiceBtn.setTitle("Add Service".localiz(), for: .normal)
        
        notificationCount = Helper.getUserDefault(key: Constants.userDefault.notificationsCount) as! String
        notificationsCountLabel.text = notificationCount
        
        getUserData()
        updateCount()
        
        if notificationCount == "0" ||  notificationCount == "" {
            notificationsCountView.isHidden = true
        }
        
        if type == "provider" {
            ordersView.isHidden = true
            orderProviderView.isHidden = false
            
            orderProviderView.backgroundColor = UIColor(named: "blue")
            add(childViewController: providerOrdersVC)
        }else {
            ordersView.isHidden = false
            orderProviderView.isHidden = true
            
            homeView.backgroundColor = UIColor(named: "blue")
            add(childViewController: HomeViewController)
        }
    }
    
    @objc func GetContainerNotifications(notification: NSNotification){
        if notification.name.rawValue == "ContainerNotification" {
            updateCount()
        }else if notification.name.rawValue == "discountNotification" {
            let storyBoard = UIStoryboard(name: Constants.storyBoard.reservation, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "DiscountRequestVC") as! DiscountRequestVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func updateCount() {
        notificationCount = Helper.getUserDefault(key: Constants.userDefault.notificationsCount) as! String
        notificationsCountLabel.text = notificationCount
    }
    
    func getUserData() {
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        type = userDate?.type ?? ""
        token = userDate?.api_token ?? ""
    }
    
    private func add(childViewController: UIViewController) {
        addChild(childViewController)
        childViewController.didMove(toParent: self)
        childViewController.view.frame = containerView.bounds
        containerView.addSubview(childViewController.view)
    }
    
    private func remove(childViewController: UIViewController) {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
    
    @IBAction func newOrder_tapped(_ sender: Any) {
        if token != "" {
            let storyBoard = UIStoryboard(name: Constants.storyBoard.provider, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "PublicReservationVC") as! PublicReservationVC
            vc.title = "New Service Order".localiz()
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            Helper.showAlert(type: Constants.AlertType.AlertWarn, title: "Alert".localiz(),
                             subTitle: "Please, Login first".localiz(),
                             closeTitle: "BACK".localiz())
        }
    }

    @IBAction func menuBtn_tapped(_ sender: Any) {
        if LanguageManger.shared.currentLanguage == .ar {
            SideMenuManager.default.rightMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "SideMenuNV") as? SideMenuNavigationController

            SideMenuManager.default.rightMenuNavigationController?.menuWidth = UIScreen.main.bounds.width - 50
            SideMenuManager.default.rightMenuNavigationController?.presentationStyle = .viewSlideOut
            SideMenuManager.default.rightMenuNavigationController?.statusBarEndAlpha = 0
            
            self.navigationController?.present(SideMenuManager.default.rightMenuNavigationController!, animated: true, completion: nil)
        }else {
            SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "SideMenuNV") as? SideMenuNavigationController

            SideMenuManager.default.leftMenuNavigationController?.menuWidth = UIScreen.main.bounds.width - 50
            SideMenuManager.default.leftMenuNavigationController?.presentationStyle = .viewSlideOut
            SideMenuManager.default.leftMenuNavigationController?.statusBarEndAlpha = 0
            
            self.navigationController?.present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
        }
    }
    
    @IBAction func homeBtn_tapped(_ sender: Any) {
        resetTabsToDefaults()
        homeView.backgroundColor = UIColor(named: "blue")
        add(childViewController: HomeViewController)
    }
    
    @IBAction func favouritesBtn_tapped(_ sender: Any) {
        if token != "" {
            resetTabsToDefaults()
            favouritesView.backgroundColor = UIColor(named: "blue")
            add(childViewController: favouriteVC)
        }else {
            Helper.showAlert(type: Constants.AlertType.AlertWarn, title: "Alert".localiz(),
                             subTitle: "Please, Login first".localiz(),
                             closeTitle: "BACK".localiz())
        }
    }
    
    @IBAction func notificationsBtn_tapped(_ sender: Any) {
        if token != "" {
            resetTabsToDefaults()
            notificationssView.backgroundColor = UIColor(named: "blue")
            add(childViewController: notificationsVC)
        }else {
            Helper.showAlert(type: Constants.AlertType.AlertWarn, title: "Alert".localiz(),
                             subTitle: "Please, Login first".localiz(),
                             closeTitle: "BACK".localiz())
        }
    }
    
    @IBAction func ordersBtn_tapped(_ sender: Any) {
        if token != "" {
            resetTabsToDefaults()
            ordersView.backgroundColor = UIColor(named: "blue")
            add(childViewController: ordersVC)
        }else {
            Helper.showAlert(type: Constants.AlertType.AlertWarn, title: "Alert".localiz(),
                             subTitle: "Please, Login first".localiz(),
                             closeTitle: "BACK".localiz())
        }
    }
    
    @IBAction func ordersProviderBtn_tapped(_ sender: Any) {
        if token != "" {
            resetTabsToDefaults()
            orderProviderView.backgroundColor = UIColor(named: "blue")
            add(childViewController: providerOrdersVC)
        }else {
            Helper.showAlert(type: Constants.AlertType.AlertWarn, title: "Alert".localiz(),
                             subTitle: "Please, Login first".localiz(),
                             closeTitle: "BACK".localiz())
        }
    }
    
    @IBAction func profileBtn_tapped(_ sender: Any) {
        if token != "" {
            resetTabsToDefaults()
            profileView.backgroundColor = UIColor(named: "blue")
            add(childViewController: editVC)
        }else {
            Helper.showAlert(type: Constants.AlertType.AlertWarn, title: "Alert".localiz(),
                             subTitle: "Please, Login first".localiz(),
                             closeTitle: "BACK".localiz())
        }
    }
    
    func resetTabsToDefaults() {
        homeView.backgroundColor = UIColor(named: "darkblue")
        favouritesView.backgroundColor = UIColor(named: "darkblue")
        notificationssView.backgroundColor = UIColor(named: "darkblue")
        ordersView.backgroundColor = UIColor(named: "darkblue")
        orderProviderView.backgroundColor = UIColor(named: "darkblue")
        profileView.backgroundColor = UIColor(named: "darkblue")
    }

}
