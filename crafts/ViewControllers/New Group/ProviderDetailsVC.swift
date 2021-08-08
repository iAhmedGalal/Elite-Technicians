//
//  ProviderDetailsVC.swift
//  salon
//
//  Created by AL Badr  on 6/13/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import ImageSlideshow

class ProviderDetailsVC: UITableViewController {
    @IBOutlet var detailsTableView: UITableView!
    @IBOutlet weak var imageSlider: ImageSlideshow!
    @IBOutlet weak var subServicesCV: UICollectionView!

    @IBOutlet weak var serviceInfo: UITextView!
    @IBOutlet weak var providerBio: UITextView!

    @IBOutlet weak var providerImage: UIImageView!
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var providerNumber: UILabel!
    @IBOutlet weak var servicesEnded: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var providerRate: FloatRatingView!
    
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var favView: RoundRectView!
  
    fileprivate var presenter: ProviderDetailsPresenter?
    
    var userImagesList: [String] = []
    var subServicesList: [SubDepartmentsModel] = []
    
    var service_ids: [Int] = []
    var service_Prices: [Double] = []
    var totalPriceDouble: Double = 0
    
    var detailsCellHight: CGFloat = 100
    var bioCellHight: CGFloat = 100
    var subServicesCellHight: CGFloat = 170

    var provider_id: Int = 0
    
    var inFav: Bool = false

    var token: String = ""
    var userId: String = ""
    
    var reservationData: ReservationModel?
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        subServicesCV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reservationData = Helper.getObjectDefault(key: Constants.userDefault.userReservation) as? ReservationModel
        service_Prices = reservationData?.service_Prices ?? []
        service_ids = reservationData?.service_ids ?? []
        
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"

        initView()
        ShowProviderDetails()
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: #selector(backBtn_tapped))

        favView.layer.cornerRadius = favView.frame.height / 2
        providerImage.layer.cornerRadius = providerImage.frame.height / 2

        subServicesCV.dataSource = self
        subServicesCV.delegate = self
        subServicesCV.register(UINib(nibName: "ProviderServicesCell", bundle: nil), forCellWithReuseIdentifier: "ProviderServicesCell")
    }
    
    func ShowProviderDetails() {
        presenter = ProviderDetailsPresenter(self)
        presenter?.GetProviderDetails(provider_id: "\(provider_id)")
    }
    
    @objc func backBtn_tapped(sender: UIBarButtonItem) {
        let reservData = ReservationModel()
        reservData.service_ids = service_ids
        reservData.service_Prices = service_Prices
        Helper.saveObjectDefault(key: Constants.userDefault.userReservation, value: reservData)
        
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        
        if indexPath.row == 0 {
            height = 225
        }else if indexPath.row == 1 {
            height = 140
        }else if indexPath.row == 2{
            height = detailsCellHight
        }else if indexPath.row == 3{
            height = bioCellHight
        }else if indexPath.row == 4{
            height = subServicesCellHight
        }else {
            height = 50
        }
        
        return height
    }
    
    @IBAction func favouriteBtn_tapped(_ sender: Any) {
        if token == "" {
            Helper.showFloatAlert(title: "Please, Login first", subTitle: "", type: Constants.AlertType.AlertError)
        }else {
            let parameters = ["provider_id": provider_id] as [String : Any]
            
            if inFav {
                presenter?.removeFromFavourite(provider_id: String(provider_id))
            }else{
                presenter?.addToFavourite(parameters: parameters)
            }
        }
    }
    
    @IBAction func requestBtn_tapped(_ sender: Any) {
        if service_ids.isEmpty {
            Helper.showFloatAlert(title: "Select Service".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else {
            let reservData = ReservationModel()
            reservData.service_ids = service_ids
            reservData.service_Prices = service_Prices
            Helper.saveObjectDefault(key: Constants.userDefault.userReservation, value: reservData)
            
            let storyboard = UIStoryboard(name: Constants.storyBoard.reservation, bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "ReservationDataVC") as! ReservationDataVC
            vc.title = "Determine lacation and time".localiz()
            vc.totalPrice = totalPriceDouble
            vc.providerId = provider_id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension ProviderDetailsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subServicesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProviderServicesCell", for: indexPath) as?
                ProviderServicesCell else {
                return UICollectionViewCell()
        }
        
        cell.configureCell(item: subServicesList[indexPath.row])
        cell.check.addTarget(self, action: #selector(selectService_tapped(_:)), for: UIControl.Event.touchUpInside)
        cell.check.tag = indexPath.row
        
        return cell
    }
    
    @objc func selectService_tapped(_ sender: UIButton) {
        guard let cell = subServicesCV.cellForItem(at: IndexPath(row: sender.tag, section: 0)) as? ProviderServicesCell else { return }
        
        if cell.check.isChecked {
            let disountPrice = Double(subServicesList[sender.tag].price_after_discount ?? "") ?? 0
            let price = Double(subServicesList[sender.tag].price ?? "") ?? 0
            
            if disountPrice == 0.0 {
                service_Prices.append(price)
            }else {
                service_Prices.append(disountPrice)
            }
            
            service_ids.append(subServicesList[sender.tag].id ?? 0)
            
            checkTotal()
            
        }else {
            guard let i = service_ids.firstIndex(of: subServicesList[sender.tag].id ?? 0) else { return }
            
            service_ids.remove(at: i)
            service_Prices.remove(at: i)
 
            checkTotal()
        }
    }
    
    
    func checkTotal() {
        totalPriceDouble = 0
        
        for price in service_Prices {
            totalPriceDouble += price
        }
        
        totalPrice.text = "\(totalPriceDouble)" + " " + ("SAR".localiz())
    }
}


extension ProviderDetailsVC: ProviderDetailsPresenterView {
    func getProvidersDetailsSuccess(_ response: Providers) {
        providerName.text = response.user_name ?? ""
        providerNumber.text = "#" + "\(response.user_id ?? 0)"
        servicesEnded.text = "\(response.done_services ?? "0")"
        
        providerRate.rating = Double(response.rate ?? 0)

        serviceInfo.text = response.services_info ?? ""
        providerBio.text = response.bio ?? ""

        providerImage.sd_setImage(with: URL(string: SITE_URL + (response.user_image ?? "")))
        
        userImagesList.append(response.cover ?? "")
        setupUserSlider()
        
        if userId == String(provider_id) {
            favView.isHidden = true
        }else {
            favView.isHidden = false
        }
        
        if response.isFav ?? false {
            inFav = true
            favBtn.setImage(#imageLiteral(resourceName: "likepink"), for: .normal)
        }else {
            inFav = false
            favBtn.setImage(#imageLiteral(resourceName: "likeborderpink"), for: .normal)
        }
  
        detailsCellHight = serviceInfo.getHeight() + 60
        bioCellHight = providerBio.getHeight() + 60

        detailsTableView.reloadData()
    }
    
    func getSubDepartmentsSuccess(_ response: [SubDepartmentsModel]) {
        subServicesList = response
        subServicesCV.reloadData()
                
        let listCount = subServicesList.count
        subServicesCellHight = CGFloat((listCount) * 140)

        checkTotal()

        detailsTableView.reloadData()
    }
    
    func AddToFavouriteSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        
        inFav = true
        favBtn.setImage(#imageLiteral(resourceName: "likepink"), for: .normal)
    }

    func removeFromFavouriteSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        
        inFav = false
        favBtn.setImage(#imageLiteral(resourceName: "likeborderpink"), for: .normal)
    }
    
    func favouriteFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}

extension ProviderDetailsVC {
    func setupUserSlider() {
        var sliderSource: [InputSource] = []
        
        if userImagesList.count != 0 {
            for i in 0 ..< userImagesList.count {
                sliderSource.append(AlamofireSource(urlString: SITE_URL + (userImagesList[i]))!)
            }
            
            imageSlider.slideshowInterval = 3.0
            imageSlider.contentScaleMode = UIView.ContentMode.scaleToFill

            imageSlider.setImageInputs(sliderSource)
            
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.sliderDidTap))
            self.imageSlider.addGestureRecognizer(recognizer)
            
        }
    }
    
    @objc func sliderDidTap() {
        imageSlider.presentFullScreenController(from: self)
    }
}

