//
//  PayOnArrivalVC.swift
//  salon
//
//  Created by AL Badr  on 6/25/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class PayOnArrivalVC: UIViewController {
    /*
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var taxNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getSettings()
    }
    
    func getSettings() {
        let userSettings = Helper.getObjectDefault(key: Constants.userDefault.userSettings) as? SettingsModel
        
        feeLabel.text = ("We will add").localiz() + " "
        feeLabel.text! += (userSettings?.every_service_money ?? "0") + " "
        feeLabel.text! += ("SAR".localiz()) + " "
        feeLabel.text! += ("to your order").localiz()
        
        taxNumberLabel.text = userSettings?.tax_number ?? "0"
        
        let reservationData = Helper.getObjectDefault(key: Constants.userDefault.userReservation) as? ReservationModel
        
        totalLabel.text = "\(reservationData?.services_total ?? 0)" + " " + ("SAR".localiz())
    }
    
    @IBAction func closeBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func proceedBtn_tapped(_ sender: Any) {
        UIApplication.shared.windows[0].rootViewController = UIStoryboard(
            name:Constants.storyBoard.main,
            bundle: nil
        ).instantiateViewController(withIdentifier: "mainNC")
    }
    */
    
}
