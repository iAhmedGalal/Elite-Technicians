//
//  CurrentOrdersVC.swift
//  salon
//
//  Created by AL Badr  on 6/18/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import MBProgressHUD

class CurrentOrdersVC: UIViewController {
    
    @IBOutlet weak var myOrdersCV: UICollectionView!
    @IBOutlet weak var noItemsView: UIView!
    
    fileprivate var presenter: CurrentOrdersPresenter?
    var ordersList: [OrdersModel] = []
    
    var provider_id: Int = 0
    var reservation_id: String = ""
    var listIndex: Int = 0
    
    var token: String = ""
    var userId: String = ""
    var type: String = ""
    
    var refresher: UIRefreshControl!
//    var hud : MBProgressHUD = MBProgressHUD()

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        myOrdersCV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = .indeterminate
        
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        type = userDate?.type ?? ""
        
        initView()
        showOrders()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(GoToOrdersNotifications), name: NSNotification.Name(rawValue: "ordersNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GoToOrdersNotifications), name: NSNotification.Name(rawValue: "completeNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GoToOrdersNotifications), name: NSNotification.Name(rawValue: "InformNotification"), object: nil)
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(populate), for: UIControl.Event.valueChanged)
        myOrdersCV.addSubview(refresher)
    }
    
    @objc func populate(){
        showOrders()
        refresher.endRefreshing()
    }
    
    @objc func GoToOrdersNotifications(notification: NSNotification){
        if notification.name.rawValue == "ordersNotification" {
            showOrders()
            
        } else if notification.name.rawValue == "completeNotification" {
            showOrders()
            
        }else {
            print("ghjfhjfghfghdfghfghcgh")
            
            let reservationId = notification.userInfo?["reservationId"] as? Int ?? 0
            
            let story = UIStoryboard(name: Constants.storyBoard.user, bundle: nil)
            let vc = story.instantiateViewController(withIdentifier:"InformManagementVC") as! InformManagementVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
            vc.orderId = reservationId
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        myOrdersCV.dataSource = self
        myOrdersCV.delegate = self
        
        myOrdersCV.register(UINib(nibName: "WaitingClientCell", bundle: nil), forCellWithReuseIdentifier: "WaitingClientCell")
        myOrdersCV.register(UINib(nibName: "DoneClientCell", bundle: nil), forCellWithReuseIdentifier: "DoneClientCell")
        myOrdersCV.register(UINib(nibName: "CancelClientCell", bundle: nil), forCellWithReuseIdentifier: "CancelClientCell")
        myOrdersCV.register(UINib(nibName: "InitialClientCell", bundle: nil), forCellWithReuseIdentifier: "InitialClientCell")
        
    }
    
    func showOrders() {
        if reservation_id == "0" {
            reservation_id = ""
        }
        
//        hud.show(animated: true)
        
        presenter = CurrentOrdersPresenter(self)
        presenter?.getClientOrders(reservation_id: reservation_id)
    }
}


extension CurrentOrdersVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if ordersList[indexPath.row].reservation_status == "done" {
            return CGSize(width: UIScreen.main.bounds.width - 16, height: 510)
        }else {
            return CGSize(width: UIScreen.main.bounds.width - 16, height: 360)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ordersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = ordersList[indexPath.row]
        
        let status = item.reservation_status
        
        if status == Constants.OrderStatus.INITIAL || status == Constants.OrderStatus.BANK_AGREE {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InitialClientCell", for: indexPath) as?
                InitialClientCell else {
                    return UICollectionViewCell()
            }
            
            cell.configCell(item: ordersList[indexPath.row])
            
            cell.cancelBtn.addTarget(self, action: #selector(ShowDeleteDialog), for: .touchUpInside)
            cell.cancelBtn.tag = indexPath.row
            
            return cell
            
        }else if status == Constants.OrderStatus.DONE {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoneClientCell", for: indexPath) as?
                DoneClientCell else {
                    return UICollectionViewCell()
            }
            
            cell.configCell(item: ordersList[indexPath.row])
            
            cell.bankBtn.addTarget(self, action: #selector(ShowBankTransferDialog), for: .touchUpInside)
            cell.bankBtn.tag = indexPath.row
            
            cell.ePayBtn.addTarget(self, action: #selector(goToEPay), for: .touchUpInside)
            cell.ePayBtn.tag = indexPath.row
            
            cell.chatBtn.addTarget(self, action: #selector(goToChat), for: .touchUpInside)
            cell.chatBtn.tag = indexPath.row
            
            cell.trackBtn.addTarget(self, action: #selector(ShowTrackDialog), for: .touchUpInside)
            cell.trackBtn.tag = indexPath.row
            
            cell.payAndRateBtn.addTarget(self, action: #selector(ShowRateDialog), for: .touchUpInside)
            cell.payAndRateBtn.tag = indexPath.row
            
            cell.cancelBtn.addTarget(self, action: #selector(ShowDeleteDialog), for: .touchUpInside)
            cell.cancelBtn.tag = indexPath.row
            
            
            
            
            return cell
            
        }else if status == Constants.OrderStatus.CHANGE_TIME {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WaitingClientCell", for: indexPath) as?
                WaitingClientCell else {
                    return UICollectionViewCell()
            }
            
            cell.configCell(item: ordersList[indexPath.row])
            
            cell.dateCancel.addTarget(self, action: #selector(ShowDeleteDialog), for: .touchUpInside)
            cell.dateCancel.tag = indexPath.row
            
            cell.suggestDateBtn.addTarget(self, action: #selector(ShowNewDatesDialog), for: .touchUpInside)
            cell.suggestDateBtn.tag = indexPath.row
            
            return cell
            
            
            
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CancelClientCell", for: indexPath) as?
                CancelClientCell else {
                    return UICollectionViewCell()
            }
            
            cell.configCell(item: ordersList[indexPath.row])
            
            cell.cancelReasonBtn.addTarget(self, action: #selector(ShowReasonsDialog), for: .touchUpInside)
            cell.cancelReasonBtn.tag = indexPath.row
            
            return cell
        }
    }
    
    @objc func ShowDeleteDialog(_ sender: UIButton) {
        listIndex = sender.tag
        let alert = UIAlertController(title: "Delete from orders?".localiz(), message:"", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes".localiz(), style: .default, handler: removeOrder))
        alert.addAction(UIAlertAction(title: "No".localiz(), style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func removeOrder(alert: UIAlertAction!) {
        let reservationId = ordersList[listIndex].reservation_id
        presenter?.deleteOrder(reservation_id: "\(reservationId)")
    }
    
    @objc func ShowReasonsDialog(_ sender: UIButton) {
        let story = UIStoryboard(name: Constants.storyBoard.user, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"ShowRejectReasonsVC") as! ShowRejectReasonsVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        vc.reservationId = ordersList[sender.tag].reservation_id
        vc.reseonsString = ordersList[sender.tag].reservation_cancel_reason
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @objc func ShowNewDatesDialog(_ sender: UIButton) {
        let story = UIStoryboard(name: Constants.storyBoard.user, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"SelectNewDateVC") as! SelectNewDateVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        vc.reservationId = ordersList[sender.tag].reservation_id
        vc.datesList = ordersList[sender.tag].reservation_suggest_newTime
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @objc func ShowBankTransferDialog(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.storyBoard.reservation, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "BankTransferVC") as! BankTransferVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
//        vc.reservationId = ordersList[sender.tag].reservation_id
//        vc.total = ordersList[sender.tag].reservation_net
//        vc.fromOrders = true
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @objc func ShowRateDialog(_ sender: UIButton) {
        listIndex = sender.tag

        if ordersList[sender.tag].reservation_if_client_end == true {
            Helper.showFloatAlert(title: "The rating was done before".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else {
            let story = UIStoryboard(name: Constants.storyBoard.user, bundle: nil)
             let vc = story.instantiateViewController(withIdentifier:"RateServiceProviderVC") as! RateServiceProviderVC
             vc.modalPresentationStyle = .overCurrentContext
             vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
             vc.reservationId = ordersList[listIndex].reservation_id
             vc.id = ordersList[listIndex].reservation_provider_id
             vc.name = ordersList[listIndex].reservation_provider_name
             vc.image = ordersList[listIndex].reservation_provider_image
             self.navigationController?.present(vc, animated: true, completion: nil)
            
//            let parameters = ["id" : ordersList[listIndex].reservation_id,
//                              "money_paid": ordersList[sender.tag].reservation_net] as [String : Any]
//
//            presenter?.endCashOrder(parameters: parameters)
            
 
        }
    }
    
    @objc func ShowTrackDialog(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.storyBoard.user, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "TrackProviderVC") as! TrackProviderVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        vc.providerId = ordersList[sender.tag].reservation_client_id
        vc.placeLat = ordersList[sender.tag].reservation_lat
        vc.placeLon = ordersList[sender.tag].reservation_lon
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @objc func goToChat(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: Constants.storyBoard.user, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.title = ordersList[sender.tag].reservation_provider_name
//        vc.clientId = ordersList[sender.tag].reservation_provider_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goToEPay(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.storyBoard.reservation, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "EPayVC") as! EPayVC
        vc.reservationId = ordersList[sender.tag].reservation_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

extension CurrentOrdersVC: CurrentOrdersPresenterView {
    func setCashSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)

        let story = UIStoryboard(name: Constants.storyBoard.user, bundle: nil)
         let vc = story.instantiateViewController(withIdentifier:"RateServiceProviderVC") as! RateServiceProviderVC
         vc.modalPresentationStyle = .overCurrentContext
         vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
         vc.reservationId = ordersList[listIndex].reservation_id
         vc.id = ordersList[listIndex].reservation_provider_id
         vc.name = ordersList[listIndex].reservation_provider_name
         vc.image = ordersList[listIndex].reservation_provider_image
         self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func setCashFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }

    func getApproveOrderSuccess(_ message: String) {}
    func getApproveOrderFailure(_ message: String) {}
    func getApplyOrderSuccess(_ message: String) {}
    func getApplyOrderFailure(_ message: String) {}
    
    func getOrdersSuccess(_ response: [OrdersModel]) {
        ordersList = response
        myOrdersCV.reloadData()
//        hud.hide(animated: true)
    }
    
    func getOrdersFailure() {
        noItemsView.isHidden = false
//        hud.hide(animated: true)
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
//        hud.hide(animated: true)
    }
}
