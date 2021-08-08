//
//  SearchServicesVC.swift
//  salon
//
//  Created by AL Badr  on 6/13/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class SearchServicesVC: UIViewController {
    @IBOutlet weak var servicesCV: UICollectionView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var noItemsView: UIView!

    var servicesList: [DepartmentsModel] = []
    var servicesFilteredList: [DepartmentsModel] = []

    var searchActive : Bool = false
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        servicesCV.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if LanguageManger.shared.currentLanguage == .ar {
            searchTF.placeholder = "ابحث هنا"
            searchTF.textAlignment = .right
        }

        initView()
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        setupKeyboard()
        
        if servicesList.isEmpty {
            noItemsView.isHidden = false
        }else {
            noItemsView.isHidden = true
            servicesFilteredList = servicesList
        }

        servicesCV.dataSource = self
        servicesCV.delegate = self
        servicesCV.register(UINib(nibName: "ServicesCell", bundle: nil), forCellWithReuseIdentifier: "ServicesCell")
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        self.searchTF.inputAccessoryView = toolbar
    }
    
    @IBAction func beginSearch(_ sender: Any) {
        searchActive = true
        servicesCV.reloadData()        
    }
    
    @IBAction func searchTextChanged(_ sender: Any) {
        servicesFilteredList = servicesList
        
        let searchString = searchTF.text ?? ""
        
        if searchString.isEmpty == false {
            servicesFilteredList = servicesList.filter({ (item) -> Bool in
                let sText: NSString = (item.department_name ?? "") as NSString
                
                return (sText.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
            })
        }
        
        servicesCV.reloadData()
    }
}

extension SearchServicesVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 5) * 0.3, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return servicesFilteredList.count
        }else {
            return servicesList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCell", for: indexPath) as?
            ServicesCell else {
                return UICollectionViewCell()
        }
        
        let services: DepartmentsModel
        
        if searchActive {
            services = servicesFilteredList[indexPath.row]
        } else {
            services = servicesList[indexPath.row]
        }
                
        cell.configureCell(item: services)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.storyBoard.reservation, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ServicesVC") as! ServicesVC
        
        if searchActive {
            if LanguageManger.shared.currentLanguage == .ar {
                vc.title = servicesFilteredList[indexPath.row].department_name ?? ""
            }else {
                vc.title = servicesFilteredList[indexPath.row].department_name_en ?? ""
            }
            
            vc.serviceId = servicesFilteredList[indexPath.row].department_id ?? 0

        } else {
            if LanguageManger.shared.currentLanguage == .ar {
                vc.title = servicesList[indexPath.row].department_name ?? ""
            }else {
                vc.title = servicesList[indexPath.row].department_name_en ?? ""
            }
            
            vc.serviceId = servicesList[indexPath.row].department_id ?? 0
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

