//
//  ArticleDetailsVC.swift
//  salon
//
//  Created by AL Badr  on 6/22/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import ImageSlideshow

class ArticleDetailsVC: UITableViewController {
    @IBOutlet var articleTable: UITableView!
    @IBOutlet weak var articleContent: UITextView!
    @IBOutlet weak var imageSlider: ImageSlideshow!

    var contentCellHight: CGFloat = 100

    fileprivate var presenter: ArticleDetailsPresenter?
    
    var imagesList: [String] = []

    var articleId: Int = 0
    var articleImage: String = ""
    var articleDescription: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()

        presenter = ArticleDetailsPresenter(self)
        presenter?.getSingleArticle(articleId: "\(articleId)")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        
        if indexPath.row == 0 {
            height = 250
        }else if indexPath.row == 1 {
            height = contentCellHight
        }
        
        return height
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        imageSlider.layer.cornerRadius = 8
        
        imagesList.append(articleImage)
        setupSlider()
        
        let data = Data((articleDescription).utf8)
        articleContent.attributedText = renderData(data: data)
        
        contentCellHight = articleContent.getHeight() + 24
        articleTable.reloadData()
    }

}

extension ArticleDetailsVC: ArticleDetailsPresenterView {
    func setArticleDetailsSuccess(_ response: Articles) {
        imagesList.append(response.image ?? "")
        setupSlider()
        
        if LanguageManger.shared.currentLanguage == .ar {
             let data = Data((response.description ?? "").utf8)
             articleContent.attributedText = renderData(data: data)
            
        }else {
             let data = Data((response.description_en ?? "").utf8)
             articleContent.attributedText = renderData(data: data)
        }
    
        contentCellHight = articleContent.getHeight() + 60
        articleTable.reloadData()
    }
    
    func setArticleDetailsFailure() {
        
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    
}

extension ArticleDetailsVC {
    func renderData(data: Data) -> NSMutableAttributedString {
        if let attributedString = try? NSMutableAttributedString(data: data, options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil) {
            
            let textRangeForFont : NSRange = NSMakeRange(0, attributedString.length)
            let font = UIFont.systemFont(ofSize: 16)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 8
            paragraphStyle.paragraphSpacing = 8
            paragraphStyle.lineBreakMode = .byWordWrapping
            
            if LanguageManger.shared.currentLanguage == .ar {
                paragraphStyle.baseWritingDirection = .rightToLeft
                paragraphStyle.alignment = .right
                
            }else {
                paragraphStyle.baseWritingDirection = .leftToRight
                paragraphStyle.alignment = .left
            }
            
            attributedString.addAttributes(
                [.paragraphStyle: paragraphStyle, .font: font], range: textRangeForFont)
            
            return attributedString
        }else {
            return NSMutableAttributedString.init(string: "")
        }
    }
    
    func setupSlider() {
        var sliderSource: [InputSource] = []
        
        if imagesList.count != 0 {
            for i in 0 ..< imagesList.count {
                sliderSource.append(AlamofireSource(urlString: SITE_URL + (imagesList[i]))!)
            }
            
            imageSlider.slideshowInterval = 3.0
            imageSlider.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
            imageSlider.contentScaleMode = UIView.ContentMode.scaleToFill
            
            let pageControl = UIPageControl()
            pageControl.currentPageIndicatorTintColor = UIColor(red: 0.78, green: 0.26, blue: 0.28, alpha: 1.00)
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


