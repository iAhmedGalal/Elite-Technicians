//
//  ReservationProvidersVC.swift
//  salon
//
//  Created by AL Badr  on 6/16/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import DropDown

class ReservationProvidersVC: UIViewController {
    @IBOutlet weak var providersCV: UICollectionView!
    @IBOutlet weak var filterSegement: UISegmentedControl!
    
    var providersList: [Providers] = []
        
    fileprivate var presenter: ServiceProvidersPresenter?
   
    var nearestFilter: String = ""
    var bestFilter: String = ""
    var favoutiteFilter: String = ""

    var service_ids: [Int] = []
    var city_id: String = ""
    var department_id: String = ""
    var listIndex: Int = 0
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        providersCV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

                
        initView()
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        providersCV.dataSource = self
        providersCV.delegate = self
        providersCV.register(UINib(nibName: "ReservationProvidersCell", bundle: nil), forCellWithReuseIdentifier: "ReservationProvidersCell")
        
        filterSegement.setTitle("Highest rated".localiz(), forSegmentAt: 0)
        filterSegement.setTitle("Closest".localiz(), forSegmentAt: 1)
        
        ShowProviders()
    }
    
    func ShowProviders() {
        presenter = ServiceProvidersPresenter(self)
        
        presenter?.getProviders(department_id: department_id, city_id: city_id)
    }
    
    
    @IBAction func segmentChanged(_ sender: Any) {
        let index = filterSegement.selectedSegmentIndex
        
        if index == 0 {//الأعلى تقييم
            city_id = ""
        }else { // الأقرب
            city_id = (Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel)?.city_id ?? ""
        }
        
        ShowProviders()
    }
    
    
}

extension ReservationProvidersVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 30) * 0.5, height: 225)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return providersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReservationProvidersCell", for: indexPath) as?
            ReservationProvidersCell else {
                return UICollectionViewCell()
        }
        
        cell.configCell(item: providersList[indexPath.row])
        
        cell.favBtn.addTarget(self, action: #selector(favBtn_tapped(_:)), for: UIControl.Event.touchUpInside)
        cell.favBtn.tag = indexPath.row
     
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.storyBoard.provider, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProviderDetailsSegmentVC") as! ProviderDetailsSegmentVC
        vc.providerName = providersList[indexPath.row].user_name ?? ""
        vc.providerId = providersList[indexPath.row].user_id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func favBtn_tapped(_ sender: UIButton) {
        listIndex = sender.tag
        let providerId = providersList[sender.tag].user_id ?? 0
        
        guard let cell = providersCV.cellForItem(at: IndexPath(row: listIndex, section: 0)) as? ReservationProvidersCell else { return }

        if cell.favBtn.image(for: .normal) == #imageLiteral(resourceName: "likepink") {
            presenter?.removeFromFavourite(provider_id: "\(providerId)")
        }else {
            let parameters = ["provider_id": providerId] as [String : Any]
            presenter?.addToFavourite(parameters: parameters)
        }
    }
}

extension ReservationProvidersVC: ServiceProvidersPresenterView {
    func getProvidersSuccess(_ response: [Providers]) {
        providersList = response
        providersCV.reloadData()
    }
    
    func getProviderFailure() {
        providersList.removeAll()
        providersCV.reloadData()
    }
    
    func AddToFavouriteSuccess(_ message: String) {
        guard let cell = providersCV.cellForItem(at: IndexPath(row: listIndex, section: 0)) as? ReservationProvidersCell else { return }
        cell.favBtn.setImage(#imageLiteral(resourceName: "likepink"), for: .normal)
        
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
    }
    
    func removeFromFavouriteSuccess(_ message: String) {
        guard let cell = providersCV.cellForItem(at: IndexPath(row: listIndex, section: 0)) as? ReservationProvidersCell else { return }
        cell.favBtn.setImage(#imageLiteral(resourceName: "likeborderpink"), for: .normal)
        
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
    }
    
    func favouriteFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}
