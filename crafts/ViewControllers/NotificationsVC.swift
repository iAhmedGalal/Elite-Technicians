//
//  NotificationsVC.swift
//  salon
//
//  Created by AL Badr  on 6/18/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//


import UIKit
import MBProgressHUD

class NotificationsVC: UIViewController {
    
    @IBOutlet weak var notificationsCV: UICollectionView!
    @IBOutlet weak var noItemsView: UIView!
    
    fileprivate var presenter: NotificationsPresenter?
    
    var notificationsList: [NotificationsModel] = []
    
    var provider_id: Int = 0
    
    var token: String = ""
    var userId: String = ""
    var notificationsCount: String = ""
    var listIndex: Int = 0
    
    var TYPE_MESSAGE: String = "new message"
    var PROVIDER_RATE_CLIENT: String = "provider rate client"
    var RESERVATION_ENDED: String = "reservation ended"
    var NEW_TIMES = "reservation suggest times"
    var NEW_RESERVATION_ADDED = "reservation added"
    var RESERVATION_APPROVED = "reservation approved"
    var RESERVATION_CANCELED = "reservation canceled"
    
    var refresher: UIRefreshControl!
//    var hud : MBProgressHUD = MBProgressHUD()

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        notificationsCV.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = .indeterminate
        
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        
        notificationsCount = Helper.getUserDefault(key: Constants.userDefault.notificationsCount) as! String
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(populate), for: UIControl.Event.valueChanged)
        notificationsCV.addSubview(refresher)

        initView()
        showNotifications()
    }
    
    @objc func populate(){
        presenter?.getMyNotifications()
        refresher.endRefreshing()
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        notificationsCV.dataSource = self
        notificationsCV.delegate = self
        notificationsCV.register(UINib(nibName: "NotificationsCell", bundle: nil), forCellWithReuseIdentifier: "NotificationsCell")
    }
    
    func showNotifications() {
        presenter = NotificationsPresenter(self)
        presenter?.getMyNotifications()
    }
}

extension NotificationsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = notificationsList[indexPath.row].message ?? ""
        let cellHeight = heightForLabel(text: text) + 80
        return CGSize(width: UIScreen.main.bounds.width - 16, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notificationsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotificationsCell", for: indexPath) as?
            NotificationsCell else {
                return UICollectionViewCell()
        }
        
        cell.configureCell(item: notificationsList[indexPath.row])
        
        return cell
    }
    
    func heightForLabel(text:String) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 64 , height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        listIndex = indexPath.row
        
        let reading = notificationsList[indexPath.row].read ?? false
        
        if reading == false {
            let notification_id = notificationsList[indexPath.row].id ?? ""
            presenter?.NotificationsRead(notification: notification_id)

            notificationsList[indexPath.row].read = true
            
            var countInt = Int(notificationsCount) ?? 1
            countInt = countInt - 1
            Helper.saveUserDefault(key: Constants.userDefault.notificationsCount, value: "\(countInt)")
        }
        
        let type = notificationsList[indexPath.row].type ?? ""
        
        switch type {
        case RESERVATION_ENDED,
             NEW_TIMES,
             NEW_RESERVATION_ADDED,
             RESERVATION_APPROVED,
             RESERVATION_CANCELED:
            if type == "provider" {
                let storyBoard = UIStoryboard(name: Constants.storyBoard.provider, bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "ProviderOrdersVC") as! ProviderOrdersVC
                vc.title = "Orders".localiz()
                vc.reservation_id = String(notificationsList[indexPath.row].name ?? 0)
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else {
                let storyBoard = UIStoryboard(name: Constants.storyBoard.user, bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "MyOrdersVC") as! MyOrdersVC
                vc.title = "My Orders".localiz()
                vc.reservation_id = String(notificationsList[indexPath.row].name ?? 0)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case PROVIDER_RATE_CLIENT:
            let storyBoard = UIStoryboard(name: Constants.storyBoard.authentication, bundle: nil)
            let editVC = storyBoard.instantiateViewController(withIdentifier: "EditVC") as! EditVC
            editVC.title = "Profile".localiz()
            editVC.fromNotifications = true
            self.navigationController?.pushViewController(editVC, animated: true)
            
        case TYPE_MESSAGE:
            let storyBoard = UIStoryboard(name: Constants.storyBoard.user, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            vc.clientId = String(notificationsList[indexPath.row].name ?? 0)
            self.navigationController?.pushViewController(vc, animated: true)

        default:
            print(type)
        }
        
    }
}

extension NotificationsVC: NotificationsPresenterView {
    func getMyNotificationsSuccess(_ response: [NotificationsModel]) {
        notificationsList = response
        notificationsCV.reloadData()
//        hud.hide(animated: true)
    }
    
    func getMyNotificationsFailure() {
        noItemsView.isHidden = false
//        hud.hide(animated: true)
    }
    
    func ReadNotificationsSuccess() {
        guard let cell = notificationsCV.cellForItem(at: IndexPath(row: listIndex, section: 0)) as? NotificationsCell else { return }
        cell.notificationImage.image = #imageLiteral(resourceName: "notificationssgray")
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
//        hud.hide(animated: true)
    }
}
