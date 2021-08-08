//
//  ShowRejectReasonsVC.swift
//  salon
//
//  Created by AL Badr  on 6/29/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ShowRejectReasonsVC: UIViewController {

    @IBOutlet weak var reason: UILabel!

    @IBOutlet weak var viewHeight: NSLayoutConstraint! //170
    
    fileprivate var presenter: ShowRejectionPresenter?

    var reseonsString: String = ""
    var reservationId: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        reason.text = reseonsString
        
        viewHeight.constant = heightForLabel(text: reseonsString) + 170
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = ShowRejectionPresenter(self)

    }
    
    @IBAction func closeBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func convincedBtn_tapped(_ sender: Any) {
        let parameters = ["reservation_id": reservationId,
                          "reason": reseonsString] as [String : Any]
        
        presenter?.makeSatisfied(parameters: parameters)
    }
    
    @IBAction func informBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

        var objectInfo = [String: Int]()
        
        objectInfo["reservationId"] = reservationId
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "InformNotification"), object: nil, userInfo: objectInfo)
        
    }
    
    func heightForLabel(text:String) -> CGFloat {
         let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 48 , height: CGFloat.greatestFiniteMagnitude))
         label.numberOfLines = 0
         label.lineBreakMode = NSLineBreakMode.byWordWrapping
         label.font = UIFont.systemFont(ofSize: 17)
         label.text = text
         
         label.sizeToFit()
         return label.frame.height
     }

}

extension ShowRejectReasonsVC: ShowRejectionPresenterView {
    func setSatisfiedSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ordersNotification"), object: nil, userInfo: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setSatisfiedFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    
}
