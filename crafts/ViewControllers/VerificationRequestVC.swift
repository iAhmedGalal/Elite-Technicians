//
//  VerificationRequestVC.swift
//  salon
//
//  Created by AL Badr  on 6/18/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class VerificationRequestVC: UITableViewController {

    @IBOutlet weak var requestImageBtn: UIButton!
    @IBOutlet weak var identityTF: UITextField!
    
    var imageList: [UIImage] = []
    
    fileprivate var presenter: VerificationRequestPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if LanguageManger.shared.currentLanguage == .ar {
            identityTF.placeholder = "رقم الهوية أو رقم الإقامة"
            identityTF.textAlignment = .right
        }
        
        setupKeyboard()
        
        presenter = VerificationRequestPresenter(self)
    }

    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        self.identityTF.inputAccessoryView = toolbar
    }
    
    @IBAction func deleteImage(_ sender: Any) {
        imageList.removeAll()
        
        requestImageBtn.setImage(#imageLiteral(resourceName: "businessblack"), for: .normal)
    }
    
    @IBAction func requestImage(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let galaryImage = #imageLiteral(resourceName: "galaryblue")
        let galaryAction = UIAlertAction(title: "Photo Library".localiz(), style: .default, handler: openGalary)
        galaryAction.setValue(galaryImage, forKey: "image")
        
        let cameraImage = #imageLiteral(resourceName: "camerablue")
        let cameraAction = UIAlertAction(title: "Camera".localiz(), style: .default, handler: openCamera)
        cameraAction.setValue(cameraImage, forKey: "image")
        
        alert.addAction(galaryAction)
        alert.addAction(cameraAction)
        alert.addAction(UIAlertAction(title: "Cancel".localiz(), style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view //to set the source of your alert
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true)
    }

    @objc func openGalary(alert: UIAlertAction!) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = false
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func openCamera(alert: UIAlertAction!) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.cameraCaptureMode = .photo
            vc.modalPresentationStyle = .fullScreen
            vc.allowsEditing = false
            vc.delegate = self
            present(vc, animated: true)
        } else {
            Helper.showFloatAlert(title: "Camera is not Available".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }
    }

    @IBAction func sendRequest(_ sender: Any) {
        tableView.isEditing = false

        if identityTF.text == "" {
            Helper.showFloatAlert(title: "Please, Enter National ID or residence number".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else {
            if imageList.isEmpty {
                Helper.showFloatAlert(title: "Please, Upload Verification Image".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
            }else {
                RequestForVerivication()
            }
        }
    }
    
    func RequestForVerivication() {
        let parameters = ["identity_id": identityTF.text ?? ""] as [String:Any]
        presenter?.VerificationRequest(parameters: parameters, imageList: imageList)
    }
    
}

extension VerificationRequestVC: VerificationRequestPresenterView {
    func getSendRequestSuccess(_ message: String) {
        Helper.ShowMainScreen(controller: self)
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
    }
    
    func getSendRequestFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    
}

extension VerificationRequestVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
        guard let image = info[.originalImage] as? UIImage else { return }
 
        imageList.removeAll()
        imageList.append(image)
        
        requestImageBtn.setImage(image, for: .normal)
        
        picker.dismiss(animated: true)

    }
}
