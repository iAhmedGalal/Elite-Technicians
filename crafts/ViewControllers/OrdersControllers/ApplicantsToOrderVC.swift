//
//  ApplicantsToOrderVC.swift
//  crafts
//
//  Created by Mahmoud Elzaiady on 22/02/2021.
//

import UIKit

class ApplicantsToOrderVC: UIViewController {
    @IBOutlet weak var providersCV: UICollectionView!
    
    var providersList: [Providers] = []
    var orderId: Int = 0
    
    fileprivate var presenter: ApplicantsToOrderPresenter?
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        providersCV.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = ApplicantsToOrderPresenter(self)

        initView()
    }
    
    func initView() {
        providersCV.dataSource = self
        providersCV.delegate = self
        providersCV.register(UINib(nibName: "OrderApplicantsCell", bundle: nil), forCellWithReuseIdentifier: "OrderApplicantsCell")
    }
    
    @IBAction func backBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
  
}

extension ApplicantsToOrderVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return providersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderApplicantsCell", for: indexPath) as?
                OrderApplicantsCell else {
                return UICollectionViewCell()
        }
        
        cell.configCell(item: providersList[indexPath.row])

        cell.acceptBtn.addTarget(self, action: #selector(acceptBtn_tapped(_:)), for: .touchUpInside)
        cell.acceptBtn.tag = indexPath.row

        cell.profileBtn.addTarget(self, action: #selector(profileBtn_tapped(_:)), for: .touchUpInside)
        cell.profileBtn.tag = indexPath.row
     
        return cell
    }
    
    @objc func acceptBtn_tapped(_ sender: UIButton) {
        let providerId = providersList[sender.tag].provider_id ?? 0
        
        let parameters = ["order_id" : orderId,
                          "provider_id": providerId,
                          "status": "confirmed"] as [String : Any]
        
        presenter?.agreeToApplicant(parameters: parameters)
    }
    
    @objc func profileBtn_tapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)

        var objectInfo = [String: Any]()

        objectInfo["id"] = providersList[sender.tag].provider_id ?? 0
        objectInfo["name"] = providersList[sender.tag].name ?? 0

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "providerNotification"), object: nil, userInfo: objectInfo)
    }
}

extension ApplicantsToOrderVC: ApplicantsToOrderPresenterView {
    func setClentDecisionSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "orderNotification"), object: nil, userInfo: nil)
    }
    
    func setClentDecisionFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}
