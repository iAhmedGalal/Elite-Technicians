//
//  PayDueVC.swift
//  salon
//
//  Created by AL Badr  on 7/7/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class PayDueVC: UIViewController {
    @IBOutlet weak var dueCV: UICollectionView!
    @IBOutlet weak var noItemsView: UIView!
    
    fileprivate var presenter: DuePresenter?
    var dueList: [DueModel] = []
    
    var page: Int = 1
    var lastPage: Int = 1
    
    var listIndex: Int = 0
    
    var refresher: UIRefreshControl!
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        dueCV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(WalletNotifications), name: NSNotification.Name(rawValue: "walletNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WalletNotifications), name: NSNotification.Name(rawValue: "ePayNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WalletNotifications), name: NSNotification.Name(rawValue: "bankNotification"), object: nil)

        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(populate), for: UIControl.Event.valueChanged)
        dueCV.addSubview(refresher)
        
        initView()
        showWallet()
    }
    
    @objc func populate(){
        page = 1
        presenter?.notPaidCommission(page: String(page))
        refresher.endRefreshing()
    }
    
    @objc func WalletNotifications(notification: NSNotification){
        if notification.name.rawValue == "walletNotification" {
            showWallet()
        }else if notification.name.rawValue == "ePayNotification" {
            let storyboard = UIStoryboard(name: Constants.storyBoard.reservation, bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "EPayVC") as! EPayVC
            vc.fromCommission = true
            vc.commissionMoney = dueList[listIndex].reservation_commission_money ?? ""
            vc.reservationId = Int(dueList[listIndex].reservation_id ?? "") ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if notification.name.rawValue == "bankNotification" {
            let storyboard = UIStoryboard(name: Constants.storyBoard.reservation, bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "BankTransferVC") as! BankTransferVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
            vc.fromCommission = true
            vc.commissionMoney = dueList[listIndex].reservation_commission_money ?? ""
            vc.reservationId = Int(dueList[listIndex].reservation_id ?? "") ?? 0
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        dueCV.dataSource = self
        dueCV.delegate = self
        dueCV.register(UINib(nibName: "PayDueCell", bundle: nil), forCellWithReuseIdentifier: "PayDueCell")
    }
    
    func showWallet() {
        presenter = DuePresenter(self)
        presenter?.notPaidCommission(page: String(page))
    }
    
}

extension PayDueVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dueList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PayDueCell", for: indexPath) as?
            PayDueCell else {
                return UICollectionViewCell()
        }
        
        cell.configPayCell(item: dueList[indexPath.row])
        
        if indexPath.row == dueList.count - 1 {
            if page < lastPage {
                page = page + 1
                showWallet()
            }
        }
        
        cell.bayBtn.addTarget(self, action: #selector(ShowPayDialog), for: .touchUpInside)
        cell.bayBtn.tag = indexPath.row
        
        return cell
    }
    
    @objc func ShowPayDialog(_ sender: UIButton) {
        listIndex = sender.tag
        
        let storyboard = UIStoryboard(name: Constants.storyBoard.reservation, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "PayDueMethodsVC") as! PayDueMethodsVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}

extension PayDueVC: DuePresenterView {
    func setLastPageSuccess(_ lPage: Int) {
        lastPage = lPage
    }
   
    func setDueFailure() {
        noItemsView.isHidden = false
    }
    
    func setPaidCommissionSuccess(_ response: [DueModel]) {

    }
    
    func setNotPaidCommissionSuccess(_ response: [DueModel]) {
        dueList.append(contentsOf: response)
        dueCV.reloadData()
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}
