//
//  MessagesVC.swift
//  salon
//
//  Created by AL Badr  on 6/18/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import MBProgressHUD

class MessagesVC: UIViewController {
    
    @IBOutlet weak var messagesCV: UICollectionView!
    @IBOutlet weak var noItemsView: UIView!
    
    fileprivate var presenter: MessagesPresenter?
    var messagesList: [MessagesModel] = []
    
    var provider_id: Int = 0
    
    var token: String = ""
    var userId: String = ""
    
    var hud : MBProgressHUD = MBProgressHUD()
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        messagesCV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        
        initView()
        showMessages()
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        messagesCV.dataSource = self
        messagesCV.delegate = self
        messagesCV.register(UINib(nibName: "MessagesCell", bundle: nil), forCellWithReuseIdentifier: "MessagesCell")
    }
    
    func showMessages() {
        hud.show(animated: true)
        presenter = MessagesPresenter(self)
        presenter?.getMyMessages()
    }
}

extension MessagesVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if messagesList[indexPath.row].last_message ?? "" == "message" {
            let text = messagesList[indexPath.row].last_message ?? ""
            let cellHeight = heightForLabel(text: text) + 96

            return CGSize(width: UIScreen.main.bounds.width - 16, height: cellHeight)
            
        }else {
            return CGSize(width: UIScreen.main.bounds.width - 16, height: 120)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messagesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessagesCell", for: indexPath) as?
            MessagesCell else {
                return UICollectionViewCell()
        }
        
        cell.configureCell(item: messagesList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: Constants.storyBoard.user, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.title = messagesList[indexPath.row].client_name ?? ""
        vc.clientId = messagesList[indexPath.row].client_id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func heightForLabel(text:String) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32 , height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
}

extension MessagesVC: MessagesPresenterView {
    func getMyMessagesSuccess(_ response: [MessagesModel]) {
        messagesList = response
        messagesCV.reloadData()
        hud.hide(animated: true)
    }
    
    func getMyMessagesFailure() {
        noItemsView.isHidden = false
        hud.hide(animated: true)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        hud.hide(animated: true)
    }
}
