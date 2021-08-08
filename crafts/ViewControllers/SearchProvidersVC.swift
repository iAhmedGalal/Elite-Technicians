//
//  SearchProvidersVC.swift
//  salon
//
//  Created by AL Badr  on 6/13/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class SearchProvidersVC: UIViewController {
    @IBOutlet weak var specialistsCV: UICollectionView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var noItemsView: UIView!

    var providersList: [Providers] = []
    var providersFilteredList: [Providers] = []

    var searchActive : Bool = false
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        specialistsCV.reloadData()
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
        
        if providersList.isEmpty {
            noItemsView.isHidden = false
        }else {
            noItemsView.isHidden = true
            providersFilteredList = providersList
        }

        specialistsCV.dataSource = self
        specialistsCV.delegate = self
        specialistsCV.register(UINib(nibName: "SpecialistCell", bundle: nil), forCellWithReuseIdentifier: "SpecialistCell")
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        self.searchTF.inputAccessoryView = toolbar
    }
    
    @IBAction func beginSearch(_ sender: Any) {
        searchActive = true
        specialistsCV.reloadData()
    }
    
    @IBAction func searchTextChanged(_ sender: Any) {
        providersFilteredList = providersList

        let searchString = searchTF.text ?? ""
        
        if searchString.isEmpty == false {
            providersFilteredList = providersList.filter({ (item) -> Bool in
                let sText: NSString = (item.user_name ?? "") as NSString
                
                return (sText.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
            })
        }
        
        specialistsCV.reloadData()
    }

}

extension SearchProvidersVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 30) * 0.5, height: 225)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return providersFilteredList.count
        }else {
            return providersList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialistCell", for: indexPath) as?
            SpecialistCell else {
                return UICollectionViewCell()
        }
        
        let providers: Providers
        
        if searchActive {
            providers = providersFilteredList[indexPath.row]
        } else {
            providers = providersList[indexPath.row]
        }
        
        cell.configureCell(item: providers)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: Constants.storyBoard.provider, bundle: Bundle.main)
//        let vc = storyboard.instantiateViewController(withIdentifier: "ProviderDetailsSegmentVC") as! ProviderDetailsSegmentVC
//        
//        if searchActive {
//            vc.providerName = providersFilteredList[indexPath.row].user_name ?? ""
//            vc.providerId = providersFilteredList[indexPath.row].user_id ?? 0
//        } else {
//            vc.providerName = providersList[indexPath.row].user_name ?? ""
//            vc.providerId = providersList[indexPath.row].user_id ?? 0
//        }
//    
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

