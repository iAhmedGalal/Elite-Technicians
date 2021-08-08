//
//  ArticlesVC.swift
//  salon
//
//  Created by AL Badr  on 6/22/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ArticlesVC: UIViewController {

    @IBOutlet weak var articlesCV: UICollectionView!
    @IBOutlet weak var noItemsView: UIView!
    
    var articlesList: [Articles] = []
    
    fileprivate var presenter: ArticlesPresenter?
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        articlesCV.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        showArticles()
    }
    
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                
        articlesCV.dataSource = self
        articlesCV.delegate = self
        articlesCV.register(UINib(nibName: "ArticlesCell", bundle: nil), forCellWithReuseIdentifier: "ArticlesCell")
    }
    
    func showArticles() {
        presenter = ArticlesPresenter(self)
        presenter?.getArticles()
    }
}

extension ArticlesVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 5) * 0.3, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articlesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticlesCell", for: indexPath) as?
            ArticlesCell else {
                return UICollectionViewCell()
        }
        
        cell.configureCell(item: articlesList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.storyBoard.main, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ArticleDetailsVC") as! ArticleDetailsVC
        vc.articleId = articlesList[indexPath.row].id ?? 0
        vc.articleImage = articlesList[indexPath.row].image ?? ""
        
        if LanguageManger.shared.currentLanguage == .ar {
            vc.title = articlesList[indexPath.row].title ?? ""
            vc.articleDescription = articlesList[indexPath.row].description ?? ""
        }else {
            vc.title = articlesList[indexPath.row].title_en ?? ""
            vc.articleDescription = articlesList[indexPath.row].description_en ?? ""
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ArticlesVC: ArticlesPresenterView {
    func setArticlesSuccess(_ response: [Articles]) {
        articlesList = response
        articlesCV.reloadData()
    }
    
    func setArticlesFailure() {
        noItemsView.isHidden = false
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}


