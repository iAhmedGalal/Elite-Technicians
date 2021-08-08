//
//  ProviderStatementVC.swift
//  salon
//
//  Created by AL Badr  on 7/7/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProviderStatementVC: UIViewController {
    @IBOutlet weak var sheetCV: UICollectionView!
    @IBOutlet weak var noItemsView: UIView!
    @IBOutlet weak var balanceLabel: UILabel!

    fileprivate var presenter: BalanceSheetPresenter?
    var sheetList: [StatementsModel] = []
    
    var provider_id: Int = 0
    
    var token: String = ""
    var userId: String = ""
    
    var page: Int = 1
    var lastPage: Int = 1
    
    var hud : MBProgressHUD = MBProgressHUD()
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        sheetCV.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        
        initView()
        showBalanceSheet()
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        sheetCV.dataSource = self
        sheetCV.delegate = self
        sheetCV.register(UINib(nibName: "ProviderSheetCell", bundle: nil), forCellWithReuseIdentifier: "ProviderSheetCell")
    }
    
    func showBalanceSheet() {
        hud.show(animated: true)
        presenter = BalanceSheetPresenter(self)
        presenter?.getProviderBalance(search: "", page: "\(page)")
    }
    
}

extension ProviderStatementVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sheetList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProviderSheetCell", for: indexPath) as?
            ProviderSheetCell else {
                return UICollectionViewCell()
        }
        
        cell.configProviderSheetCell(item: sheetList[indexPath.row])
        
        if indexPath.row == sheetList.count - 1 {
            if page < lastPage {
                page = page + 1
                showBalanceSheet()
            }
        }
        
        return cell
    }
}

extension ProviderStatementVC: BalanceSheetPresenterView {
    func getClientSheetSuccess(_ response: [StatementsModel]) {
        sheetList = response
        sheetCV.reloadData()
        hud.hide(animated: true)
    }
    
    func getClientSheetFailure() {
        noItemsView.isHidden = false
        hud.hide(animated: true)
    }
    
    func getProviderSheetSuccess(_ response: [StatementsModel]) {
        sheetList = response
        sheetCV.reloadData()
        hud.hide(animated: true)
    }
    
    func getProviderSheetFailure() {
        noItemsView.isHidden = false
        hud.hide(animated: true)
    }
    
    func setBalanceSuccess(_ balance: String) {
        balanceLabel.text = balance
    }
    
    func setLastPageSuccess(_ lPage: Int) {
        lastPage = lPage
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        hud.hide(animated: true)
    }
 
}
