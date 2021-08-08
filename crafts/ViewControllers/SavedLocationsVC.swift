//
//  SavedLocationsVC.swift
//  salon
//
//  Created by AL Badr  on 6/18/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//


import UIKit
import MBProgressHUD

class SavedLocationsVC: UIViewController {
    
    @IBOutlet weak var placesCV: UICollectionView!
    @IBOutlet weak var noItemsView: UIView!
    
    fileprivate var presenter: PlacesPresenter?
    
    var placesList: [LocationsModel] = []
    
    var provider_id: Int = 0
    
    var token: String = ""
    var userId: String = ""
    var listIndex: Int = 0
    
    var hud : MBProgressHUD = MBProgressHUD()
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        placesCV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        
        NotificationCenter.default.addObserver(self, selector: #selector(GetLocationNotifications), name: NSNotification.Name(rawValue: "locationNotification"), object: nil)
        
        initView()
        showPlaces()
    }
    
    @objc func GetLocationNotifications(notification: NSNotification){
        if notification.name.rawValue == "locationNotification" {
            let lat = notification.userInfo?["lat"] as? String ?? ""
            let lon = notification.userInfo?["lon"] as? String ?? ""
            let title = notification.userInfo?["placeTitle"] as? String ?? ""
            
            print("latlon", lat + "---" + lon)
            
            let parameters = ["title": title,
                              "lat":  lat,
                              "lon":  lon] as [String:Any]
            
            presenter?.AddPlace(parameters: parameters)
        }
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        placesCV.dataSource = self
        placesCV.delegate = self
        placesCV.register(UINib(nibName: "LocationsCell", bundle: nil), forCellWithReuseIdentifier: "LocationsCell")
    }
    
    func showPlaces() {
        hud.show(animated: true)
        presenter = PlacesPresenter(self)
        presenter?.getPlaces()
    }
    
    @IBAction func chooseLocationBtn_tapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: Constants.storyBoard.main, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChooseLocationVC") as! ChooseLocationVC
        vc.newPlace = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SavedLocationsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return placesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationsCell", for: indexPath) as?
            LocationsCell else {
                return UICollectionViewCell()
        }
        
        cell.configCell(item: placesList[indexPath.row])
        
        cell.chooseRadioBtn.isHidden = true
        
        cell.deleteBtn.addTarget(self, action: #selector(ShowDeleteDialog(_:)), for: UIControl.Event.touchUpInside)
        cell.deleteBtn.tag = indexPath.row
        
        return cell
    }
    
    @objc func ShowDeleteDialog(_ sender: UIButton) {
        listIndex = sender.tag
        let alert = UIAlertController(title: "Delete from places?".localiz(), message:"", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes".localiz(), style: .default, handler: removeFavourite))
        alert.addAction(UIAlertAction(title: "No".localiz(), style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func removeFavourite(alert: UIAlertAction!) {
        let place_id = placesList[listIndex].place_id ?? 0
        presenter?.RemovePlace(place_id: "\(place_id)")
    }
}

extension SavedLocationsVC: PlacesPresenterView {
    func getPlacesSuccess(_ response: [LocationsModel]) {
        placesList = response
        placesCV.reloadData()
        hud.hide(animated: true)
        noItemsView.isHidden = true
    }
    
    func getPlacesFailure() {
        noItemsView.isHidden = false
        hud.hide(animated: true)
    }
    
    func getAddPlaceSuccess() {
        showPlaces()
    }
    
    func getAddPlaceFailure() {
        
    }
    
    func getRemovePlaceSuccess() {
        placesList.remove(at: listIndex)
        placesCV.reloadData()
    }
    
    func getRemovePlaceFailure() {
    }

    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        hud.hide(animated: true)
    }
}
