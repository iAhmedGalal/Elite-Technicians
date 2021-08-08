//
//  PagesDetailsVC.swift
//  salon
//
//  Created by AL Badr  on 6/18/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class PagesDetailsVC: UITableViewController {
    
    @IBOutlet var pageTable: UITableView!
    @IBOutlet weak var pageContent: UITextView!
    
    var pageId: Int = 0
    var contentCellHight: CGFloat = 100

    fileprivate var presenter: PageDetailsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        presenter = PageDetailsPresenter(self)
        
        if pageId == 1 { //about
            presenter?.GetPageDetails()
        }else {
            presenter?.GetPolicy()
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        
        if indexPath.row == 0 {
            height = contentCellHight
        }else {
            height = 60
        }
        
        return height
    }
    
    func renderData(data: Data) -> NSMutableAttributedString {
        if let attributedString = try? NSMutableAttributedString(data: data, options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil) {
            
            let textRangeForFont : NSRange = NSMakeRange(0, attributedString.length)
            let font = UIFont.systemFont(ofSize: 14)
            let paragraphStyle = NSMutableParagraphStyle()
            
            if LanguageManger.shared.currentLanguage == .ar {
                paragraphStyle.alignment = .right
                paragraphStyle.baseWritingDirection = .rightToLeft
            }else {
                paragraphStyle.alignment = .left
                paragraphStyle.baseWritingDirection = .leftToRight
            }

            paragraphStyle.lineSpacing = 8
            paragraphStyle.paragraphSpacing = 8
            paragraphStyle.lineBreakMode = .byWordWrapping
            
            attributedString.addAttributes(
                [.paragraphStyle: paragraphStyle, .font: font], range: textRangeForFont)
            
            return attributedString
        }else {
            return NSMutableAttributedString.init(string: "")
        }
    }

}

extension PagesDetailsVC: PageDetailsPresenterView {
    func setPolicySuccess(_ contacts: PolicyModel) {
        if LanguageManger.shared.currentLanguage == .ar {
            let data = Data((contacts.data_ar ?? "").utf8)
            pageContent.attributedText = renderData(data: data)
        }else {
            let data = Data((contacts.data_en ?? "").utf8)
            pageContent.attributedText = renderData(data: data)
        }
        
        contentCellHight = pageContent.getHeight() + 24
        pageTable.reloadData()
    }
    
    func getPageContentSuccess(_ content: InfoModel) {
        if pageId == 1 { //about
            if LanguageManger.shared.currentLanguage == .ar {
                let data = Data((content.about_ar ?? "").utf8)
                pageContent.attributedText = renderData(data: data)
            }else {
                let data = Data((content.about_en ?? "").utf8)
                pageContent.attributedText = renderData(data: data)
            }
        }else {
            if LanguageManger.shared.currentLanguage == .ar {
                let data = Data((content.policy_ar ?? "").utf8)
                pageContent.attributedText = renderData(data: data)
            }else {
                let data = Data((content.policy_en ?? "").utf8)
                pageContent.attributedText = renderData(data: data)
            }
        }
        
        contentCellHight = pageContent.getHeight() + 24
        pageTable.reloadData()
    }

    func getPageDetailsFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}
