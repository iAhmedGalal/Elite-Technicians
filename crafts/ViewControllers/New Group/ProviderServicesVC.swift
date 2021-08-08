//
//  ProviderServices.swift
//  crafts
//
//  Created by AL Badr  on 1/18/21.
//

import UIKit
import DropDown

class ProviderServicesVC: UITableViewController {
    @IBOutlet var serviceTable: UITableView!

    @IBOutlet weak var name_arTF: UITextField!
    @IBOutlet weak var name_enTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    
    @IBOutlet weak var servicesCV: UICollectionView!
    
    @IBOutlet weak var serviceImageBtn: UIButton!
    @IBOutlet weak var mainSectionBtn: UIButton!
    @IBOutlet weak var subSectionBtn: UIButton!

    var serviceList: [SubDepartmentsModel] = []

    var mainSectionsList: [DepartmentsModel] = []
    var subSectionsList: [SubDepartmentsModel] = []
    var serviceImageList: [UIImage] = []
    
    var mainSections:[String] = []
    let mainSectionsDropDown = DropDown()
    var selectedMainSectionId: String = ""
    
    var subSections:[String] = []
    let subSectionsDropDown = DropDown()
    var selectedSubSectionId: String = ""
    
    var servicesCellHight: CGFloat = 100
    
    fileprivate var presenter: ProviderServicesPresenter?
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        servicesCV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if LanguageManger.shared.currentLanguage == .ar {
            name_arTF.placeholder = "Service name".localiz()
            name_arTF.textAlignment = .right
            
            name_enTF.placeholder = "Service name in English".localiz()
            name_enTF.textAlignment = .right
            
            priceTF.placeholder = "Service price".localiz()
            priceTF.textAlignment = .right
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(GetOfferNotifications), name: NSNotification.Name(rawValue: "offerNotification"), object: nil)

        initView()
        setupKeyboard()
    }
    
    @objc func GetOfferNotifications(notification: NSNotification){
        if notification.name.rawValue == "offerNotification" {
            presenter?.getProviderServices()
        }
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        name_arTF.inputAccessoryView = toolbar
        name_enTF.inputAccessoryView = toolbar
        priceTF.inputAccessoryView = toolbar
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                
        servicesCV.dataSource = self
        servicesCV.delegate = self
        servicesCV.register(UINib(nibName: "ProviderNewServicesCell", bundle: nil), forCellWithReuseIdentifier: "ProviderNewServicesCell")

        presenter = ProviderServicesPresenter(self)
        presenter?.getProviderServices()
        presenter?.GetMainServices()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        
        if indexPath.row == 0 {
            height = 150
        }else if indexPath.row == 7{
            height = servicesCellHight
        }else {
            height = 55
        }
        
        return height
    }

    func setupMainsDropDown() {
        mainSections.removeAll()
        
        for mainSection in mainSectionsList{
            if LanguageManger.shared.currentLanguage == .ar {
                mainSections.append(mainSection.department_name ?? "")
            }else {
                mainSections.append(mainSection.department_name_en ?? "")
            }
        }
        
        mainSectionsDropDown.anchorView = mainSectionBtn
        mainSectionsDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        mainSectionsDropDown.dataSource = self.mainSections
        mainSectionsDropDown.selectionAction = { [unowned self](index, item) in
            self.mainSectionBtn.setTitle(item, for: .normal)
 
            self.selectedMainSectionId = "\(self.mainSectionsList[index].department_id ?? 0)"
            self.presenter?.GetSubServices(department_id: self.selectedMainSectionId)
        }
    }
    
    func setupSubsDropDown() {
        subSections.removeAll()
        
        for subSection in subSectionsList{
            if LanguageManger.shared.currentLanguage == .ar {
                subSections.append(subSection.name_ar ?? "")
            }else {
                subSections.append(subSection.name_en ?? "")
            }
        }
        
        subSectionsDropDown.anchorView = subSectionBtn
        subSectionsDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        subSectionsDropDown.dataSource = self.subSections
        subSectionsDropDown.selectionAction = { [unowned self](index, item) in
            self.subSectionBtn.setTitle(item, for: .normal)
            
            self.selectedSubSectionId = "\(self.subSectionsList[index].id ?? 0)"
        }
    }
    
    func showAddImageAlert() {
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
        
    @IBAction func serviceImageBtn_tapped(_ sender: Any) {
        showAddImageAlert()
    }
    
    @IBAction func mainSectionBtn_tapped(_ sender: Any) {
        mainSectionsDropDown.show()
    }
    
    @IBAction func subSectionBtn_tapped(_ sender: Any) {
        subSectionsDropDown.show()
    }
    
    @IBAction func addServiceBtn_tapped(_ sender: Any) {
        if name_arTF.text == "" {
            Helper.showFloatAlert(title: "Enter service Arabic name".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else if name_enTF.text == "" {
            Helper.showFloatAlert(title: "Enter service English name".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else if priceTF.text == "" {
            Helper.showFloatAlert(title: "Enter service price".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else if selectedMainSectionId == "" {
            Helper.showFloatAlert(title: "Choose service main section".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else if selectedSubSectionId == "" {
            Helper.showFloatAlert(title: "Choose service subsection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else if serviceImageList.isEmpty {
            Helper.showFloatAlert(title: "Attach service image".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else {
            AddNewService()
        }
    }
    
    func AddNewService() {
        let num = (priceTF.text ?? "").arToEnDigits
        let newNum = num.replacingOccurrences(of: "٫", with: ".")
        priceTF.text = newNum
        
        let parameters = ["name": name_arTF.text ?? "",
                          "name_en": name_enTF.text ?? "",
                          "department_id": selectedMainSectionId,
                          "sub_department_id": selectedSubSectionId,
                          "price": priceTF.text ?? ""] as [String:Any]
        
        presenter?.AddService(parameters: parameters, image: serviceImageList)
    }
    
    func resetData() {
        name_arTF.text = ""
        name_enTF.text = ""
        priceTF.text = ""
        selectedMainSectionId = ""
        selectedSubSectionId = ""
        serviceImageList.removeAll()
        serviceImageBtn.setImage(#imageLiteral(resourceName: "imagegray"), for: .normal)
    }
    
}


extension ProviderServicesVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serviceList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProviderNewServicesCell", for: indexPath) as?
                ProviderNewServicesCell else {
                return UICollectionViewCell()
        }
        
        cell.configureCell(item: serviceList[indexPath.row])
        
        cell.addOfferBtn.addTarget(self, action: #selector(addOffer_tapped(_:)), for: UIControl.Event.touchUpInside)
        cell.addOfferBtn.tag = indexPath.row
        
        cell.removeOfferBtn.addTarget(self, action: #selector(removeOffer_tapped(_:)), for: UIControl.Event.touchUpInside)
        cell.removeOfferBtn.tag = indexPath.row
        
        cell.removeServiceBtn.addTarget(self, action: #selector(removeService_tapped(_:)), for: UIControl.Event.touchUpInside)
        cell.removeServiceBtn.tag = indexPath.row
        
        return cell
    }
    
    @objc func addOffer_tapped(_ sender: UIButton) {
        let story = UIStoryboard(name: Constants.storyBoard.provider, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"NewOfferVC") as! NewOfferVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        vc.service_id = serviceList[sender.tag].id ?? 0
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @objc func removeOffer_tapped(_ sender: UIButton) {
        let service_id = serviceList[sender.tag].id ?? 0
        let parameters = ["service_id": service_id,
                          "offer_price": "0"] as [String:Any]
        presenter?.RemoveOffer(parameters: parameters)
    }
    
    @objc func removeService_tapped(_ sender: UIButton) {
        let service_id = serviceList[sender.tag].id ?? 0
        let parameters = ["service_id": service_id] as [String:Any]
        presenter?.RemoveService(parameters: parameters)
        
        serviceList.remove(at: sender.tag)
        servicesCV.reloadData()
    }

}

extension ProviderServicesVC: ProviderServicesPresenterView {
    func getDepartmentsSuccess(_ response: [DepartmentsModel]) {
        mainSectionsList = response
        setupMainsDropDown()
    }
    
    func getSubDepartmentsSuccess(_ response: [SubDepartmentsModel]) {
        subSectionsList = response
        setupSubsDropDown()
    }
    
    func getServicesSuccess(_ response: [SubDepartmentsModel]) {
        serviceList = response
        servicesCV.reloadData()
        
        servicesCellHight = CGFloat(serviceList.count) * 146
        serviceTable.reloadData()
    }

    func getAddServiceSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        
        resetData()
        presenter?.getProviderServices()
    }
    
    func getEditServiceSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
    }
    
    func getRemoveServiceSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
    }
    
    func getRemoveOfferSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
    }
    
    func getDepartmentsFailure() {
        mainSectionsList.removeAll()
        setupMainsDropDown()
        
        subSectionBtn.setTitle("No sections found".localiz(), for: .normal)
    }
    
    func getSubDepartmentsFailure() {
        subSectionsList.removeAll()
        setupSubsDropDown()
        
        subSectionBtn.setTitle("No sections found".localiz(), for: .normal)
    }
    
    func getServicesFailure() {}
    

    func getAddServiceFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func getEditServiceFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func getRemoveServiceFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func getRemoveOfferFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }

    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}

extension ProviderServicesVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        serviceImageList.removeAll()
        serviceImageList.append(image)
        serviceImageBtn.setImage(image, for: .normal)
        
        picker.dismiss(animated: true)
    }
}

