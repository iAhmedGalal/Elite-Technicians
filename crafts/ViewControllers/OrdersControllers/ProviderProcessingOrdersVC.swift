//
//  ProviderProcessingOrdersVC.swift
//  crafts
//
//  Created by AL Badr  on 1/19/21.
//

import UIKit
import ObjectMapper
import Alamofire
import SwiftyJSON
import MBProgressHUD

class ProviderProcessingOrdersVC: UIViewController {
    @IBOutlet weak var myOrdersCV: UICollectionView!
    @IBOutlet weak var noItemsView: UIView!
    
    fileprivate var presenter: CurrentOrdersPresenter?
    var ordersList: [OrdersModel] = []
    var reservationDetailsList: [Reservation_details] = []
    var reservation_suggest_newTime : [NewDates] = []

    
    var provider_id: Int = 0
    var reservation_id: String = ""
    var listIndex: Int = 0
    
    var token: String = ""
    var userId: String = ""
    var type: String = ""
    
    var page: Int = 1
    var lastPage: Int = 1
    
    var refresher: UIRefreshControl!

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        myOrdersCV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        type = userDate?.type ?? ""
        
        presenter = CurrentOrdersPresenter(self)

        initView()
        showOrders()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(GoToOrdersNotifications), name: NSNotification.Name(rawValue: "ordersNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GoToOrdersNotifications), name: NSNotification.Name(rawValue: "rateNotification"), object: nil)
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(populate), for: UIControl.Event.valueChanged)
        myOrdersCV.addSubview(refresher)
 
    }
    
    @objc func populate(){
        page = 1
        ordersList.removeAll()
        myOrdersCV.reloadData()
        showOrders()
        refresher.endRefreshing()
    }
    
    @objc func GoToOrdersNotifications(notification: NSNotification){
        if notification.name.rawValue == "ordersNotification" {
            ordersList.removeAll()
            myOrdersCV.reloadData()
            showOrders()
            
        }else if notification.name.rawValue == "rateNotification" {
            
            let reservationId = notification.userInfo?["reservationId"] as? Int ?? 0
            
            print("reservationId", reservationId)
            
            let story = UIStoryboard(name: Constants.storyBoard.user, bundle: nil)
            let vc = story.instantiateViewController(withIdentifier:"RateServiceProviderVC") as! RateServiceProviderVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
            vc.reservationId = reservationId
            vc.id = ordersList[listIndex].reservation_client_id
            vc.name = ordersList[listIndex].reservation_client_name
            vc.image = ordersList[listIndex].reservation_client_image
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        myOrdersCV.dataSource = self
        myOrdersCV.delegate = self
        
        myOrdersCV.register(UINib(nibName: "RequiredProviderCell", bundle: nil), forCellWithReuseIdentifier: "RequiredProviderCell")
        myOrdersCV.register(UINib(nibName: "ConfirmedProviderCell", bundle: nil), forCellWithReuseIdentifier: "ConfirmedProviderCell")
        myOrdersCV.register(UINib(nibName: "RejectedProviderCell", bundle: nil), forCellWithReuseIdentifier: "RejectedProviderCell")
        myOrdersCV.register(UINib(nibName: "WaitingProviderCell", bundle: nil), forCellWithReuseIdentifier: "WaitingProviderCell")
        myOrdersCV.register(UINib(nibName: "CompletedProviderCell", bundle: nil), forCellWithReuseIdentifier: "CompletedProviderCell")

    }
    
    func showOrders() {
        if reservation_id == "0" {
            reservation_id = ""
        }
        
//        presenter?.getProviderOrders(reservation_id: reservation_id)
        
        let Headers : HTTPHeaders = ["Content-Type":"application/json",
                                            "Accept":"application/json"]
        
//        var hud : MBProgressHUD = MBProgressHUD()
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = .indeterminate

        let url = Constants.Urls.PROVIDER_ORDERS + "?api_token=" + token  + "&reservation_id=" + reservation_id + "&page=" + "\(page)"
  
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Headers).responseJSON { (response) in

//            hud.show(animated: true)

            switch response.result {
            case .failure(_):
//                hud.hide(animated: true)
                Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)

            case .success(_):
//                hud.hide(animated: true)

                let reData = JSON(response.value as Any)
                
                print("reData", reData)

                let status =  reData["status"].boolValue
                
                self.lastPage = reData["meta"]["last_page"].intValue

                if status == false {
                    self.noItemsView.isHidden = false
                }else {
                    
                    guard let newData = (reData["data"].arrayObject) else { return }
                    
                    for newD in newData {
                        let reDa = JSON(newD as Any)
                        let reservation_client_id = reDa["reservation_client_id"].stringValue
                        let reservation_comment = reDa["reservation_comment"].stringValue
                        let reservation_suggest_newTime = reDa["reservation_suggest_newTime"].arrayValue
                        let reservation_addedValue = reDa["reservation_addedValue"].intValue
                        let reservation_paymentType = reDa["reservation_paymentType"].stringValue
                        let reservation_client_image = reDa["reservation_client_image"].stringValue
                        let reservation_provider_name = reDa["reservation_provider_name"].stringValue
                        let reservation_lat = reDa["reservation_lat"].stringValue
                        let reservation_net = reDa["reservation_net"].stringValue
                        let reservation_if_client_end = reDa["reservation_if_client_end"].boolValue
                        let reservation_rest = reDa["reservation_rest"].stringValue
                        let reservation_money_pay = reDa["reservation_money_pay"].stringValue
                        let reservation_id = reDa["reservation_id"].intValue
                        let reservation_status = reDa["reservation_status"].stringValue
                        let reservation_total = reDa["reservation_total"].stringValue
                        let reservation_client_name = reDa["reservation_client_name"].stringValue
                        let reservation_date = reDa["reservation_date"].stringValue
                        let reservation_provider_id = reDa["reservation_provider_id"].stringValue
                        let reservation_lon = reDa["reservation_lon"].stringValue
                        let reservation_address = reDa["reservation_address"].stringValue
                        let reservation_addValue = reDa["reservation_addValue"].stringValue
                        let reservation_cancel_reason = reDa["reservation_cancel_reason"].stringValue
                        let reservation_provider_image = reDa["reservation_provider_image"].stringValue
                        let reservation_details = reDa["reservation_details"].arrayValue
                        let reservation_if_provider_end = reDa["reservation_if_provider_end"].boolValue
                        let reservation_time = reDa["reservation_time"].stringValue
                        let reservation_if_follow_open = reDa["reservation_if_follow_open"].boolValue
                        
                        for dates in reservation_suggest_newTime {
                            let newData = JSON(dates as Any)
                            
                            let suggest_id = newData["suggest_id"].intValue
                            let suggest_time = newData["suggest_time"].stringValue
                            let suggest_service_id = newData["suggest_service_id"].stringValue
                            let suggest_to = newData["suggest_to"].stringValue
                            let suggest_date = newData["suggest_date"].stringValue
                            let suggestTimeAPI = newData["suggestTimeAPI"].stringValue
                            
                            let newDateModel = NewDates()
                            newDateModel.suggest_id = suggest_id
                            newDateModel.suggest_time = suggest_time
                            newDateModel.suggest_service_id = suggest_service_id
                            newDateModel.suggest_to = suggest_to
                            newDateModel.suggest_date = suggest_date
                            newDateModel.suggestTimeAPI = suggestTimeAPI
                            
                            self.reservation_suggest_newTime.append(newDateModel)
                        }
                        
                        for details in reservation_details {
                            let newDetails = JSON(details as Any)
                            
                            let details_id = newDetails["details_id"].intValue
                            let details_price = newDetails["details_price"].stringValue
                            let details_department_name = newDetails["details_department_name"].stringValue
                            let details_department_name_en = newDetails["details_department_name_en"].stringValue
                            
                            var newDetailsModel = Reservation_details()
                            newDetailsModel.details_id = details_id
                            newDetailsModel.details_price = details_price
                            newDetailsModel.details_department_name = details_department_name
                            newDetailsModel.details_department_name_en = details_department_name_en
                            
                            self.reservationDetailsList.append(newDetailsModel)
                        }

                        var newOrder = OrdersModel()
                        newOrder.reservation_client_id = reservation_client_id
                        newOrder.reservation_comment = reservation_comment
                        newOrder.reservation_suggest_newTime = self.reservation_suggest_newTime
                        newOrder.reservation_addedValue = reservation_addedValue
                        newOrder.reservation_paymentType = reservation_paymentType
                        newOrder.reservation_client_image = reservation_client_image
                        newOrder.reservation_provider_name = reservation_provider_name
                        newOrder.reservation_lat = reservation_lat
                        newOrder.reservation_net = reservation_net
                        newOrder.reservation_if_client_end = reservation_if_client_end
                        newOrder.reservation_rest = reservation_rest
                        newOrder.reservation_money_pay = reservation_money_pay
                        newOrder.reservation_id = reservation_id
                        newOrder.reservation_status = reservation_status
                        newOrder.reservation_total = reservation_total
                        newOrder.reservation_client_name = reservation_client_name
                        newOrder.reservation_date = reservation_date
                        newOrder.reservation_provider_id = reservation_provider_id
                        newOrder.reservation_lon = reservation_lon
                        newOrder.reservation_address = reservation_address
                        newOrder.reservation_addValue = reservation_addValue
                        newOrder.reservation_cancel_reason = reservation_cancel_reason
                        newOrder.reservation_provider_image = reservation_provider_image
                        newOrder.reservation_details = self.reservationDetailsList
                        newOrder.reservation_if_provider_end = reservation_if_provider_end
                        newOrder.reservation_time = reservation_time
                        newOrder.reservation_if_follow_open = reservation_if_follow_open
                        
                        if reservation_client_id != "" {
                            self.ordersList.append(newOrder)
                        }
                    }
                    
                    self.myOrdersCV.reloadData()
                    
                }
            }
        }
    }
    
    
}


extension ProviderProcessingOrdersVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let status = ordersList[indexPath.row].reservation_status
        if  status == "initial" || status ==  "done" {
            return CGSize(width: UIScreen.main.bounds.width - 16, height: 420)
        }else {
            return CGSize(width: UIScreen.main.bounds.width - 16, height: 370)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ordersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = ordersList[indexPath.row]
        
        let status = item.reservation_status
        
        if status == Constants.OrderStatus.INITIAL {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RequiredProviderCell", for: indexPath) as?
                RequiredProviderCell else {
                    return UICollectionViewCell()
            }
            
            cell.configCell(item: ordersList[indexPath.row])
            
            cell.dateBtn.addTarget(self, action: #selector(ShowNewDatesDialog), for: .touchUpInside)
            cell.dateBtn.tag = indexPath.row
            
            cell.rejectBtn.addTarget(self, action: #selector(SendReasonsDialog), for: .touchUpInside)
            cell.rejectBtn.tag = indexPath.row
            
            cell.confirmBtn.addTarget(self, action: #selector(confirmOrder_tapped), for: .touchUpInside)
            cell.confirmBtn.tag = indexPath.row
            
            if indexPath.row == ordersList.count - 1 {
                if page < lastPage {
                    page = page + 1
                    showOrders()
                }
            }
            
            return cell
            
        }else if status == Constants.OrderStatus.DONE {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConfirmedProviderCell", for: indexPath) as?
                ConfirmedProviderCell else {
                    return UICollectionViewCell()
            }
            
            cell.configCell(item: ordersList[indexPath.row])
            
            cell.chatBtn.addTarget(self, action: #selector(goToChat(_:)), for: .touchUpInside)
            cell.chatBtn.tag = indexPath.row
            
            cell.locationBtn.addTarget(self, action: #selector(ShowTrackDialog), for: .touchUpInside)
            cell.locationBtn.tag = indexPath.row
            
            cell.completeBtn.addTarget(self, action: #selector(ShowReceiveCashDialog), for: .touchUpInside)
            cell.completeBtn.tag = indexPath.row
            
            cell.finishBtn.addTarget(self, action: #selector(ShowRateDialog), for: .touchUpInside)
            cell.finishBtn.tag = indexPath.row
            
            if indexPath.row == ordersList.count - 1 {
                if page < lastPage {
                    page = page + 1
                    showOrders()
                }
            }

            return cell
            
        }else if status == Constants.OrderStatus.CHANGE_TIME {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WaitingProviderCell", for: indexPath) as?
                WaitingProviderCell else {
                    return UICollectionViewCell()
            }
            
            cell.configCell(item: ordersList[indexPath.row])
            
            cell.rejectBtn.addTarget(self, action: #selector(SendReasonsDialog), for: .touchUpInside)
            cell.rejectBtn.tag = indexPath.row
            
            cell.confirmBtn.addTarget(self, action: #selector(confirmOrder_tapped), for: .touchUpInside)
            cell.confirmBtn.tag = indexPath.row
            
            if indexPath.row == ordersList.count - 1 {
                if page < lastPage {
                    page = page + 1
                    showOrders()
                }
            }
            
            return cell
            
        }else if status == Constants.OrderStatus.END {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompletedProviderCell", for: indexPath) as?
                CompletedProviderCell else {
                    return UICollectionViewCell()
            }
            
            cell.configCell(item: ordersList[indexPath.row])
            
            if indexPath.row == ordersList.count - 1 {
                if page < lastPage {
                    page = page + 1
                    showOrders()
                }
            }
                        
            return cell
            
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RejectedProviderCell", for: indexPath) as?
                RejectedProviderCell else {
                    return UICollectionViewCell()
            }
            
            cell.configCell(item: ordersList[indexPath.row])
            
            if indexPath.row == ordersList.count - 1 {
                if page < lastPage {
                    page = page + 1
                    showOrders()
                }
            }
            
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
    
    @objc func SendReasonsDialog(_ sender: UIButton) {
        let story = UIStoryboard(name: Constants.storyBoard.provider, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"RejectionReasonsVC") as! RejectionReasonsVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        vc.orderId = ordersList[sender.tag].reservation_id
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @objc func ShowNewDatesDialog(_ sender: UIButton) {
        let story = UIStoryboard(name: Constants.storyBoard.provider, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"SuggestTimeVC") as! SuggestTimeVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        vc.reservationId = ordersList[sender.tag].reservation_id
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @objc func ShowReceiveCashDialog(_ sender: UIButton) {
        listIndex = sender.tag
        
        if ordersList[sender.tag].reservation_if_provider_end == true {
            Helper.showFloatAlert(title: "The rating was done before".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else {
            let story = UIStoryboard(name: Constants.storyBoard.provider, bundle: nil)
            let vc = story.instantiateViewController(withIdentifier:"ReceiveCashVC") as! ReceiveCashVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
            vc.reservationId = ordersList[sender.tag].reservation_id
            vc.total = ordersList[sender.tag].reservation_net
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func ShowBankTransferDialog(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.storyBoard.reservation, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "BankTransferVC") as! BankTransferVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
//        vc.reservationId = ordersList[sender.tag].reservation_id
        
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @objc func ShowRateDialog(_ sender: UIButton) {
        listIndex = sender.tag
        
        if ordersList[sender.tag].reservation_if_provider_end == true {
            Helper.showFloatAlert(title: "The rating was done before".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else {
     
            let parameters = ["id" : ordersList[listIndex].reservation_id,
                              "money_paid": ordersList[sender.tag].reservation_net] as [String : Any]
            
            presenter?.endCashOrder(parameters: parameters)
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
        vc.title = ordersList[sender.tag].reservation_client_name
//        vc.clientId = ordersList[sender.tag].reservation_client_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func confirmOrder_tapped(_ sender: UIButton) {
        let reservationId = ordersList[sender.tag].reservation_id
        let parameters = ["id": reservationId] as [String:Any]
        presenter?.approveOrder(parameters: parameters)
    }
    
    
    
}

extension ProviderProcessingOrdersVC: CurrentOrdersPresenterView {
    func getApplyOrderSuccess(_ message: String) {}
    
    func getApplyOrderFailure(_ message: String) {}
    
    func setCashSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)

        let story = UIStoryboard(name: Constants.storyBoard.user, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"RateServiceProviderVC") as! RateServiceProviderVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        vc.reservationId = ordersList[listIndex].reservation_id
        vc.id = ordersList[listIndex].reservation_client_id
        vc.name = ordersList[listIndex].reservation_client_name
        vc.image = ordersList[listIndex].reservation_client_image
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func setCashFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func getOrdersSuccess(_ response: [OrdersModel]) {
        ordersList = response
        myOrdersCV.reloadData()
    }
    
    func getOrdersFailure() {
        noItemsView.isHidden = false
    }
    
    func getApproveOrderSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        ordersList.removeAll()
        myOrdersCV.reloadData()
        showOrders()
    }
    
    func getApproveOrderFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
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
