//
//  RequestDueVC.swift
//  salon
//
//  Created by AL Badr  on 7/7/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class RequestDueVC: UIViewController {
    @IBOutlet weak var dueCV: UICollectionView!
    @IBOutlet weak var noItemsView: UIView!
    
    fileprivate var presenter: DuePresenter?
    var dueList: [DueModel] = []
    
    var page: Int = 1
    var lastPage: Int = 1
    
    var refresher: UIRefreshControl!
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        dueCV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(WalletNotifications), name: NSNotification.Name(rawValue: "dueNotification"), object: nil)
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(populate), for: UIControl.Event.valueChanged)
        dueCV.addSubview(refresher)
        
        initView()
        showWallet()
    }
    
    @objc func populate(){
        page = 1
        presenter?.paidCommission(page: String(page))
        refresher.endRefreshing()
    }

    @objc func WalletNotifications(notification: NSNotification){
        if notification.name.rawValue == "dueNotification" {
            showWallet()
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
        presenter?.paidCommission(page: String(page))
   }
    
}

extension RequestDueVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if dueList[indexPath.row].admin_agree == "agree" {
            return CGSize(width: UIScreen.main.bounds.width - 16, height: 300)
        }else {
            return CGSize(width: UIScreen.main.bounds.width - 16, height: 250)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dueList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PayDueCell", for: indexPath) as?
                PayDueCell else {
            return UICollectionViewCell()
        }
        
        cell.configRequestCell(item: dueList[indexPath.row])
        
        if indexPath.row == dueList.count - 1 {
            if page < lastPage {
                page = page + 1
                showWallet()
            }
        }
    
        return cell
    }

    @objc func ShowRequestDialog(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: Constants.storyBoard.provider, bundle: Bundle.main)
//        let vc = storyboard.instantiateViewController(withIdentifier: "ConfirmDueVC") as! ConfirmDueVC
//        vc.modalPresentationStyle = .overCurrentContext
//        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
//        vc.reservationId = dueList[sender.tag].reservation_id ?? ""
//        self.navigationController?.present(vc, animated: true, completion: nil)
    }

}

extension RequestDueVC: DuePresenterView {
    func setPaidCommissionSuccess(_ response: [DueModel]) {
        dueList.append(contentsOf: response)
        dueCV.reloadData()
    }
    
    func setNotPaidCommissionSuccess(_ response: [DueModel]) {
        
    }
    
    func setLastPageSuccess(_ lPage: Int) {
        lastPage = lPage
    }
    
    func setDueFailure() {
        noItemsView.isHidden = false
    }

    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}
