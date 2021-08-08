//
//  CommentsObjectionVC.swift
//  crafts
//
//  Created by Mahmoud Elzaiady on 10/02/2021.
//

import UIKit

class CommentsObjectionVC: UIViewController {

    @IBOutlet weak var objectionTF: UITextView!
    
    var commentId: Int = 0
    
    fileprivate var presenter: ProfileCommentsPresenter?
    
    var type: String = ""

    override func viewWillAppear(_ animated: Bool) {
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        type = userDate?.type ?? ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        type = userDate?.type ?? ""
        
        setupKeyboard()
        
        if LanguageManger.shared.currentLanguage == .ar {
            objectionTF.text = "اسباب الاعتراض"
            objectionTF.textAlignment = .right
        }

        presenter = ProfileCommentsPresenter(self)
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        objectionTF.inputAccessoryView = toolbar
        objectionTF.delegate = self
    }

    @IBAction func backBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtn_tapped(_ sender: Any) {
        if objectionTF.text == "" {
            Helper.showFloatAlert(title: "Please enter your objection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else {
            sendObjection()
        }
    }
    
    func sendObjection() {
        let parameters = ["objection": objectionTF.text ?? ""] as [String : Any]
        
        if type == "provider" {
            presenter?.ObjectionCommentProvider(comment_id: "\(commentId)", parameters: parameters)
        }else {
            presenter?.ObjectionCommentClient(comment_id: "\(commentId)", parameters: parameters)
        }
    }

}

extension CommentsObjectionVC: ProfileCommentsPresenterView {
    func getProviderCommentsSuccess(_ response: [CommentsModel]) {}
    func getClientCommentsSuccess(_ response: [CommentsModel]) {}
    func getCommentsFailure() {}
    
    func getCommentsObjectionSuccess(_ response: String) {
        Helper.showFloatAlert(title: response, subTitle: "", type: Constants.AlertType.AlertSuccess)
                
        self.dismiss(animated: true, completion: nil)
    }
    
    func getCommentsObjectionFailure(_ response: String) {
        Helper.showFloatAlert(title: response, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}

extension CommentsObjectionVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if objectionTF.text == "Objection Reasons".localiz() {
            objectionTF.text = ""
            objectionTF.textColor = .black
        }
    }
}

