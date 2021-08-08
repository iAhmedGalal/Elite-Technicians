//
//  FavouritesVC.swift
//  salon
//
//  Created by AL Badr  on 6/18/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import MBProgressHUD

class FavouritesVC: UIViewController {
    @IBOutlet weak var favouritesCV: UICollectionView!
    @IBOutlet weak var noItemsView: UIView!
    
    fileprivate var presenter: FavouritesPresenter?
    
    var favouritesList: [FavouritesModel] = []
    
    var provider_id: Int = 0
    
    var token: String = ""
    var userId: String = ""
    
    var listIndex: Int = 0
    
//    var hud : MBProgressHUD = MBProgressHUD()
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        favouritesCV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = .indeterminate
        
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        
        initView()
        showFavourites()
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        favouritesCV.dataSource = self
        favouritesCV.delegate = self
        favouritesCV.register(UINib(nibName: "SpecialistCell", bundle: nil), forCellWithReuseIdentifier: "SpecialistCell")
    }
    
    func showFavourites() {
//        hud.show(animated: true)
        presenter = FavouritesPresenter(self)
        presenter?.getMyFavourites()
    }
}

extension FavouritesVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 30) * 0.5, height: 225)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favouritesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialistCell", for: indexPath) as?
            SpecialistCell else {
                return UICollectionViewCell()
        }
        
        cell.deleteBtn.isHidden = false
        cell.configFavouriteCell(item: favouritesList[indexPath.row])
        
        cell.deleteBtn.addTarget(self, action: #selector(ShowDeleteDialog(_:)), for: UIControl.Event.touchUpInside)
        cell.deleteBtn.tag = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.storyBoard.provider, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProviderDetailsSegmentVC") as! ProviderDetailsSegmentVC
        vc.providerName = favouritesList[indexPath.row].user_name ?? ""
        vc.providerId = favouritesList[indexPath.row].user_id ?? 0
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func ShowDeleteDialog(_ sender: UIButton) {
        listIndex = sender.tag
        let alert = UIAlertController(title: "Delete from favourites?".localiz(), message:"", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes".localiz(), style: .default, handler: removeFavourite))
        alert.addAction(UIAlertAction(title: "No".localiz(), style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func removeFavourite(alert: UIAlertAction!) {
        let clientId = favouritesList[listIndex].user_id ?? 0
        presenter?.removeFromFavourite(provider_id: "\(clientId)")
    }
}

extension FavouritesVC: FavouritesPresenterView {
    func getMyFavouritesSuccess(_ response: [FavouritesModel]) {
        favouritesList = response
        favouritesCV.reloadData()
//        hud.hide(animated: true)
    }
    
    func getMyFavouritesFailure() {
        noItemsView.isHidden = false
//        hud.hide(animated: true)
    }
    
    func removeFromFavouriteSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        favouritesList.remove(at: listIndex)
        favouritesCV.reloadData()
    }
    
    func removeFromFavouriteFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)

    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
//        hud.hide(animated: true)
    }
}
