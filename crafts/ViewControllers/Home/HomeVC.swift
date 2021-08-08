//
//  HomeVC.swift
//  crafts
//
//  Created by AL Badr  on 12/28/20.
//

import UIKit
import ImageSlideshow

class HomeVC: UITableViewController {
    @IBOutlet weak var homeTable: UITableView!
    
    @IBOutlet weak var imageSlider: ImageSlideshow!
    @IBOutlet weak var servicesCV: UICollectionView!
    @IBOutlet weak var articlesCV: UICollectionView!
    
    var imagesList: [Slider] = []
    var servicesList: [DepartmentsModel] = []
    var articlesList: [Articles] = []
    
    fileprivate var presenter: HomePresenter?
    
    var token: String = ""
    var userId: String = ""
    
    var refresher: UIRefreshControl!
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        servicesCV.reloadData()
        articlesCV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        
        print("user token", token)
        print("user id", userId)
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(populate), for: UIControl.Event.valueChanged)
        homeTable.addSubview(refresher)
        
        presenter = HomePresenter(self)
        presenter?.GetHome()
        presenter?.getSettings()
        
        initView()
    }
    
    @objc func populate(){
        presenter?.GetHome()
        refresher.endRefreshing()
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        imageSlider.layer.cornerRadius = 8
        
        servicesCV.dataSource = self
        servicesCV.delegate = self
        servicesCV.register(UINib(nibName: "ServicesCell", bundle: nil), forCellWithReuseIdentifier: "ServicesCell")
        
        articlesCV.dataSource = self
        articlesCV.delegate = self
        articlesCV.register(UINib(nibName: "ArticlesCell", bundle: nil), forCellWithReuseIdentifier: "ArticlesCell")
    }
    
    @IBAction func shawServicesBtn_tapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: Constants.storyBoard.main, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchServicesVC") as! SearchServicesVC
        vc.title = "Services".localiz()
        vc.servicesList = servicesList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func shawArticlesBtn_tapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: Constants.storyBoard.main, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ArticlesVC") as! ArticlesVC
        vc.title = "Articles".localiz()
        vc.articlesList = articlesList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case servicesCV:
            return CGSize(width: 130, height: 150)
        default:
            return CGSize(width: 150, height: 150)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case servicesCV:
            return servicesList.count
        default:
            return articlesList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case servicesCV:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCell", for: indexPath) as?
                    ServicesCell else {
                return UICollectionViewCell()
            }
            
            cell.configureCell(item: servicesList[indexPath.row])
            
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticlesCell", for: indexPath) as?
                    ArticlesCell else {
                return UICollectionViewCell()
            }
            
            cell.configureCell(item: articlesList[indexPath.row])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case servicesCV:
            let storyboard = UIStoryboard(name: Constants.storyBoard.reservation, bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "ServicesVC") as! ServicesVC
            
            if LanguageManger.shared.currentLanguage == .ar {
                vc.title = servicesList[indexPath.row].department_name ?? ""
            }else {
                vc.title = servicesList[indexPath.row].department_name_en ?? ""
            }
            
            vc.serviceId = servicesList[indexPath.row].department_id ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
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
}


extension HomeVC: HomePresenterView {
    func getSliderSuccess(_ response: [Slider]) {
        imagesList = response
        setupSlider()
    }
    
    func getDepartmentsSuccess(_ response: [DepartmentsModel]) {
        servicesList = response
        servicesCV.reloadData()
    }
    
    func getArticlesSuccess(_ response: [Articles]) {
        articlesList = response
        articlesCV.reloadData()
    }
    
    func getNotificationsCountSuccess(_ response: Int) {
        Helper.saveUserDefault(key: Constants.userDefault.notificationsCount, value: "\(response)")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContainerNotification"), object: nil)
    }
    
    func getOrdersCountSuccess(_ response: Int) {
        Helper.saveUserDefault(key: Constants.userDefault.ordersCount, value: "\(response)")
    }
    
    func getSettingsSuccess(_ response: SettingsModel) {
        Helper.saveObjectDefault(key: Constants.userDefault.userSettings, value: response)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}

extension HomeVC {
    func setupSlider() {
        var sliderSource: [InputSource] = []
        
        if imagesList.count != 0 {
            for i in 0 ..< imagesList.count {
                sliderSource.append(AlamofireSource(urlString: SITE_URL + (imagesList[i].image ?? ""))!)
            }
            
            imageSlider.slideshowInterval = 3.0
            imageSlider.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
            imageSlider.contentScaleMode = UIView.ContentMode.scaleToFill
            
            let pageControl = UIPageControl()
            pageControl.currentPageIndicatorTintColor = UIColor(red: 0.20, green: 0.56, blue: 0.78, alpha: 1.00)
            pageControl.pageIndicatorTintColor = UIColor.lightGray
            imageSlider.pageIndicator = pageControl
            imageSlider.activityIndicator = DefaultActivityIndicator()
            imageSlider.setImageInputs(sliderSource)
            
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.sliderDidTap))
            self.imageSlider.addGestureRecognizer(recognizer)
            
        }
    }
    
    @objc func sliderDidTap() {
        imageSlider.presentFullScreenController(from: self)
    }
}

