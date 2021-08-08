//
//  ProviderPendingOrdersVC.swift
//  crafts
//
//  Created by AL Badr  on 1/19/21.
//

import UIKit

class ProviderPendingOrdersVC: UIViewController {
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

        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        type = userDate?.type ?? ""
        
        initView()
        showOrders()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(GoToOrdersNotifications), name: NSNotification.Name(rawValue: "applyNotification"), object: nil)

        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(populate), for: UIControl.Event.valueChanged)
        myOrdersCV.addSubview(refresher)
    }
    
    @objc func populate(){
        showOrders()
        refresher.endRefreshing()
    }
    
    @objc func GoToOrdersNotifications(notification: NSNotification){
        if notification.name.rawValue == "applyNotification" {
            showOrders()
        }
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        myOrdersCV.dataSource = self
        myOrdersCV.delegate = self
        
        myOrdersCV.register(UINib(nibName: "ApplyToOrderCell", bundle: nil), forCellWithReuseIdentifier: "ApplyToOrderCell")
    }
    
    func showOrders() {
        if reservation_id == "0" {
            reservation_id = ""
        }
        
//        hud.show(animated: true)
        
        presenter = CurrentOrdersPresenter(self)
        presenter?.getPublicOrders(reservation_id: reservation_id)
    }
}


extension ProviderPendingOrdersVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let status = ordersList[indexPath.row].status ?? ""
        
        if status == "pending" {
            return CGSize(width: UIScreen.main.bounds.width - 16, height: 175)
        }else {
            return CGSize(width: UIScreen.main.bounds.width - 16, height: 270)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ordersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplyToOrderCell", for: indexPath) as?
                ApplyToOrderCell else {
                return UICollectionViewCell()
        }
        
        cell.configCell(item: ordersList[indexPath.row])
        
        cell.dateBtn.addTarget(self, action: #selector(ShowNewDatesDialog), for: .touchUpInside)
        cell.dateBtn.tag = indexPath.row
        
        cell.applyBtn.addTarget(self, action: #selector(ShowApplyDialog), for: .touchUpInside)
        cell.applyBtn.tag = indexPath.row
        
        return cell
    }
    
    @objc func ShowApplyDialog(_ sender: UIButton) {
        let story = UIStoryboard(name: Constants.storyBoard.provider, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"ApplyToOrderVC") as! ApplyToOrderVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        vc.reservationId = ordersList[sender.tag].id ?? 0
        vc.date = ordersList[sender.tag].date ?? ""
        vc.time = ordersList[sender.tag].time ?? ""
        vc.describtion = ordersList[sender.tag].description ?? ""
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
        
}

extension ProviderPendingOrdersVC: CurrentOrdersPresenterView {
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
//        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
//        hud.hide(animated: true)
    }
}
