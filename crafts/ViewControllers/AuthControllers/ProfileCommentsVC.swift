//
//  ProfileCommentsVC.swift
//  salon
//
//  Created by AL Badr  on 7/14/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ProfileCommentsVC: UIViewController {
    @IBOutlet weak var commentsCV: UICollectionView!
    @IBOutlet weak var noItemsView: UIView!
    
    fileprivate var presenter: ProfileCommentsPresenter?
    var commentsList: [CommentsModel] = []
    
    var provider_id: Int = 0
    
    var type: String = ""
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        commentsCV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        type = userDate?.type ?? ""
        
        initView()
        showComments()
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        commentsCV.dataSource = self
        commentsCV.delegate = self
        commentsCV.register(UINib(nibName: "CommentsCell", bundle: nil), forCellWithReuseIdentifier: "CommentsCell")
    }
    
    func showComments() {
        presenter = ProfileCommentsPresenter(self)
        
        if type == "provider" {
            presenter?.GetProviderComments()
        }else {
            presenter?.GetClientComments()
        }
    }
}

extension ProfileCommentsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = commentsList[indexPath.row].comment ?? ""
        let cellHeight = heightForLabel(text: text) + 100

        return CGSize(width: UIScreen.main.bounds.width - 16, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        commentsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentsCell", for: indexPath) as?
            CommentsCell else {
                return UICollectionViewCell()
        }
        
        cell.configureCell(item: commentsList[indexPath.row])
        cell.objectionView.isHidden = false
        
        cell.objectionBtn.addTarget(self, action: #selector(objectionBtn_tapped(_:)), for: UIControl.Event.touchUpInside)
        cell.objectionBtn.tag = indexPath.row
        
        return cell
    }
    
    func heightForLabel(text:String) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 16 , height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    @objc func objectionBtn_tapped(_ sender: UIButton) {
        let story = UIStoryboard(name: Constants.storyBoard.provider, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"CommentsObjectionVC") as! CommentsObjectionVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        vc.commentId = commentsList[sender.tag].rate_id ?? 0
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}

extension ProfileCommentsVC: ProfileCommentsPresenterView {
    func getProviderCommentsSuccess(_ response: [CommentsModel]) {
        commentsList = response
        commentsCV.reloadData()
    }
    
    func getClientCommentsSuccess(_ response: [CommentsModel]) {
        commentsList = response
        commentsCV.reloadData()
    }
    
    func getCommentsFailure() {
        noItemsView.isHidden = false
    }
    
    func getCommentsObjectionSuccess(_ response: String) {}
    func getCommentsObjectionFailure(_ response: String) {}
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}
