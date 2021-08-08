//
//  SelectNewDateVC.swift
//  salon
//
//  Created by AL Badr  on 6/29/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class SelectNewDateVC: UIViewController {

    @IBOutlet weak var datesCV: UICollectionView!
    
    var datesList: [NewDates] = []
    var reservationId: Int = 0
    
    fileprivate var presenter: SubmitNewDatePresenter?
    
    var selectedDateId: Int = -1

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        datesCV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        datesCV.dataSource = self
        datesCV.delegate = self
        datesCV.register(UINib(nibName: "LocationsCell", bundle: nil), forCellWithReuseIdentifier: "LocationsCell")
        
        datesCV.reloadData()
        
        presenter = SubmitNewDatePresenter(self)
    }
    
    @IBAction func backBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmBtn_tapped(_ sender: Any) {
        if selectedDateId == -1 {
            Helper.showFloatAlert(title: "Choose the new date".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else {
            submitDate()
        }
    }
    
    func submitDate() {
        let parameters = ["id" : reservationId,
                          "time_id": selectedDateId] as [String : Any]
        
        presenter?.submitNewDate(parameters: parameters)
    }

}

extension SelectNewDateVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationsCell", for: indexPath) as?
            LocationsCell else {
                return UICollectionViewCell()
        }
        
        cell.configDatesCell(item: datesList[indexPath.row])
        cell.chooseRadioBtn.isChecked = false
        cell.deleteBtn.isHidden = true
        
        cell.chooseRadioBtn.addTarget(self, action: #selector(ShowDeleteDialog(_:)), for: UIControl.Event.touchUpInside)
        cell.chooseRadioBtn.tag = indexPath.row
        
        return cell
    }
    
    @objc func ShowDeleteDialog(_ sender: UIButton) {
        selectedDateId = datesList[sender.tag].suggest_id ?? -1

        for i in 0..<datesList.count {
            guard let cell = datesCV.cellForItem(at: IndexPath(row: i, section: 0)) as? LocationsCell else { return }
            i == sender.tag ? cell.setSelected(selected: true) : cell.setSelected(selected: false)
        }

    }
    
}

extension SelectNewDateVC: SubmitNewDatePresenterView {
    func setNewDateSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ordersNotification"), object: nil, userInfo: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setNewDateFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}
