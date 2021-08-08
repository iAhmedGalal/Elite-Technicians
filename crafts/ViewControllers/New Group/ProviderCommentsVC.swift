//
//  ProviderCommentsVC.swift
//  salon
//
//  Created by AL Badr  on 6/13/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ProviderCommentsVC: UIViewController {
    @IBOutlet weak var commentsCV: UICollectionView!
    @IBOutlet weak var noItemsView: UIView!
    
    fileprivate var presenter: ProviderCommentsPresenter?
    var commentsList: [CommentsModel] = []
    
    var provider_id: Int = 0

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        commentsCV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        showProviderComments()
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        commentsCV.dataSource = self
        commentsCV.delegate = self
        commentsCV.register(UINib(nibName: "CommentsCell", bundle: nil), forCellWithReuseIdentifier: "CommentsCell")
    }
    
    func showProviderComments() {
        presenter = ProviderCommentsPresenter(self)
        presenter?.GetProviderComments(provider_id: "\(provider_id)")
    }
}

extension ProviderCommentsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16, height: 100)
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
        cell.objectionView.isHidden = true
        
        return cell
    }
}

extension ProviderCommentsVC: ProviderCommentsPresenterView {
    func getProviderCommentsSuccess(_ response: [CommentsModel]) {
        commentsList = response
        commentsCV.reloadData()
    }
    
    func getProviderCommentsFailure() {
        noItemsView.isHidden = false
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    
}
