//
//  ServicesVC.swift
//  salon
//
//  Created by AL Badr  on 6/13/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ServicesVC: UIViewController {
    @IBOutlet weak var subServicesCV: UICollectionView!

    var subServicesList: [SubDepartmentsModel] = []

    fileprivate var presenter: ServicesPresenter?
    
    var serviceId: Int = 0
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        subServicesCV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                
        subServicesCV.dataSource = self
        subServicesCV.delegate = self
        subServicesCV.register(UINib(nibName: "SubServiceCell", bundle: nil), forCellWithReuseIdentifier: "SubServiceCell")
        
        presenter = ServicesPresenter(self)
        presenter?.GetSubServices(department_id: "\(serviceId)")
    }
}

extension ServicesVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 30) * 0.5, height: 225)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subServicesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubServiceCell", for: indexPath) as?
            SubServiceCell else {
                return UICollectionViewCell()
        }
        
        cell.configureCell(item: subServicesList[indexPath.row])
     
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: Constants.storyBoard.reservation, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ReservationProvidersVC") as! ReservationProvidersVC
        
        if LanguageManger.shared.currentLanguage == .ar {
            vc.title = String(subServicesList[indexPath.row].name ?? "")
        }else {
            vc.title = String(subServicesList[indexPath.row].name_en ?? "")
        }
        
        vc.department_id = String(subServicesList[indexPath.row].id ?? 0)
        navigationController?.pushViewController(vc, animated: true)
    }
  
}

extension ServicesVC: ServicesPresenterView {
    func getSubDepartmentsSuccess(_ response: [SubDepartmentsModel]) {
        subServicesList = response
        subServicesCV.reloadData()
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}
