//
//  PreviousOrdersVC.swift
//  salon
//
//  Created by AL Badr  on 6/18/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import MBProgressHUD

class PreviousOrdersVC: UIViewController {

    @IBOutlet weak var myOrdersCV: UICollectionView!
    @IBOutlet weak var noItemsView: UIView!
    
    fileprivate var presenter: PreviousOrdersPresenter?
    var ordersList: [OrdersModel] = []
    
    var provider_id: Int = 0
    
    var token: String = ""
    var userId: String = ""
    var listIndex: Int = 0
    
    var refresher: UIRefreshControl!

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        myOrdersCV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GoToNotifications), name: NSNotification.Name(rawValue: "providerNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GoToNotifications), name: NSNotification.Name(rawValue: "orderNotification"), object: nil)

        
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        
        initView()
        showOrders()
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(populate), for: UIControl.Event.valueChanged)
        myOrdersCV.addSubview(refresher)
    }
    
    @objc func GoToNotifications(notification: NSNotification){
        if notification.name.rawValue == "providerNotification" {
            let id = notification.userInfo?["id"] as? Int ?? 0
            let name = notification.userInfo?["name"] as? String ?? ""
            
            let storyboard = UIStoryboard(name: Constants.storyBoard.provider, bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "ProviderDetailsSegmentVC") as! ProviderDetailsSegmentVC
            vc.providerName = name
            vc.providerId = id
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if notification.name.rawValue == "orderNotification" {
            showOrders()
        }
    }
    
    
    @objc func populate(){
        showOrders()
        refresher.endRefreshing()
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        myOrdersCV.dataSource = self
        myOrdersCV.delegate = self
        myOrdersCV.register(UINib(nibName: "WaitingOrderCell", bundle: nil), forCellWithReuseIdentifier: "WaitingOrderCell")
    }
    
    func showOrders() {
        presenter = PreviousOrdersPresenter(self)
        presenter?.getPreviousOrders(reservation_id: "")
    }
}

extension PreviousOrdersVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16, height: 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ordersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WaitingOrderCell", for: indexPath) as?
                WaitingOrderCell else {
                return UICollectionViewCell()
        }
        
        cell.configCell(item: ordersList[indexPath.row])
        
        cell.cancelBtn.addTarget(self, action: #selector(ShowDeleteDialog), for: .touchUpInside)
        cell.cancelBtn.tag = indexPath.row
        
        cell.applicantsBtn.addTarget(self, action: #selector(ShowProvidersDialog), for: .touchUpInside)
        cell.applicantsBtn.tag = indexPath.row
        
        return cell
    }
    
    @objc func ShowProvidersDialog(_ sender: UIButton) {
        let story = UIStoryboard(name: Constants.storyBoard.provider, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"ApplicantsToOrderVC") as! ApplicantsToOrderVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        vc.providersList = ordersList[sender.tag].providers ?? []
        vc.orderId = ordersList[sender.tag].id ?? 0
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @objc func ShowDeleteDialog(_ sender: UIButton) {
        listIndex = sender.tag
        let alert = UIAlertController(title: "Delete from orders?".localiz(), message:"", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes".localiz(), style: .default, handler: removeOrder))
        alert.addAction(UIAlertAction(title: "No".localiz(), style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func removeOrder(alert: UIAlertAction!) {
        let reservationId = ordersList[listIndex].id ?? 0
        presenter?.deleteOrder(reservation_id: "\(reservationId)")
    }
}

extension PreviousOrdersVC: PreviousOrdersPresenterView {
    func getMyOrdersSuccess(_ response: [OrdersModel]) {
        ordersList = response
        myOrdersCV.reloadData()
    }
    
    func getMyOrdersFailure() {
        noItemsView.isHidden = false
    }
    
    func removeOrderSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        
        ordersList.remove(at: listIndex)
        myOrdersCV.reloadData()
    }
    
    func removeOrderFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}
