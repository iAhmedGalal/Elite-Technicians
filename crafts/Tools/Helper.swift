//
//  OFCHelper.swift
//  OrangeFootballClub
//
//  Created by Zeinab Reda on 11/15/16.
//  Copyright © 2016 Alaa Taher. All rights reserved.
//

import UIKit
import SCLAlertView
import JDropDownAlert
import SideMenu
import Foundation

public extension UIImage {
    func base64Encode() -> String? {
        guard let imageData = self.pngData() else {
            return nil
        }
        
        let base64String = imageData.base64EncodedString()
        let fullBase64String = "data:image/png;base64,\(base64String))"
        
        return fullBase64String
    }
    
    func getCropRatio() -> CGFloat {
        let widthRatio = CGFloat(self.size.width / self.size.height)
        return widthRatio
    }
}

extension UITextView {
    func getHeight() -> CGFloat {
        let maximumLabelSize: CGSize = CGSize(width: 343, height: 99999)
        let expectedLabelSize: CGSize = self.sizeThatFits(maximumLabelSize)
        var newFrame: CGRect = self.frame
        newFrame.size.height = expectedLabelSize.height
        return newFrame.size.height
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func setupKeyboardToolbar() -> UIToolbar {
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "تم", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        return toolbar
    }
}

extension String {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
//    
//    public var arToEnDigits : String {
//        let arabicNumbers = ["٠": "0","١": "1","٢": "2","٣": "3","٤": "4","٥": "5","٦": "6","٧": "7","٨": "8","٩": "9"]
//        var txt = self
//        arabicNumbers.map { txt = txt.replacingOccurrences(of: $0, with: $1)}
//        return txt
//    }
}


extension UILabel{
    func underLine(){
        if let textUnwrapped = self.text{
            let underlineAttribute = [kCTUnderlineStyleAttributeName: NSUnderlineStyle.single.rawValue]
            let underlineAttributedString = NSAttributedString(string: textUnwrapped, attributes: underlineAttribute as [NSAttributedString.Key : Any])
            self.attributedText = underlineAttributedString
        }
    }
}

extension UIAlertController {
    func changeFont(view:UIView,font:UIFont) {
        for item in view.subviews {
            if item is UICollectionView {
                let col = item as! UICollectionView
                for  row in col.subviews{
                    self.changeFont(view: row, font: font)
                }
            }
            if item is UILabel {
                let label = item as! UILabel
                label.font = font
            }else {
                self.changeFont(view: item, font: font)
            }
            
        }
    }
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //        let font =  UIFont(name: "GE SS", size: 16.0)!
        //        changeFont(view: self.view, font: font )
    }
}

class Helper: NSObject {
    
    static let userDef = UserDefaults.standard
    static let levelDic = NSDictionary(objects: ["Poussin","Minime","Cadet","Junior","Pro D2","Pro D1","Coach"], forKeys: [1 as NSCopying,2 as NSCopying,3 as NSCopying,4 as NSCopying,5 as NSCopying,6 as NSCopying,7 as NSCopying])
    
    
    static func goToLoginScreen(controller:UIViewController) {
        let storyBoard = UIStoryboard(name: Constants.storyBoard.authentication, bundle: nil)
        let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC")
        loginVC.title = "Login".localiz()
        controller.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    static func ShowMainScreen(controller: UIViewController) {
        UIApplication.shared.windows[0].rootViewController = UIStoryboard(
             name:Constants.storyBoard.main,
             bundle: nil
        ).instantiateViewController(withIdentifier: "mainNC")
        
//        controller.navigationController?.popToRootViewController(animated: true)
    }
    
    /*
    static func convertDataToJson(data:Data) ->Any
    {
        var jsonDic : Any?
        do {
            jsonDic = try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions())
        }
        return jsonDic as Any
    }
    */

    
    static func showFloatAlert(title:String ,subTitle:String ,type:Int){

        let alert = JDropDownAlert()
        alert.alertWith(title)
        //        alert.titleFont = UIFont(name: "Helvetica", size: 20)!
        //        alert.messageFont = UIFont.italicSystemFont(ofSize: 12)

        if type == Constants.AlertType.AlertError
        {
            alert.alertWith(title, message: subTitle, topLabelColor: UIColor.white, messageLabelColor: UIColor.darkGray, backgroundColor: UIColor.red)
        }
        else if type == Constants.AlertType.AlertSuccess
        {
            alert.alertWith(title, message: subTitle, topLabelColor: UIColor.white, messageLabelColor: UIColor.darkGray, backgroundColor: UIColor(red:0.25, green:0.62, blue:0.81, alpha:1.0))

        }

        else if type == Constants.AlertType.AlertWarn
        {
            alert.alertWith(title, message: subTitle, topLabelColor: UIColor.white, messageLabelColor: UIColor.darkGray, backgroundColor: UIColor.yellow)

        }
        alert.didTapBlock = {
            //print("Top View Did Tapped")
        }
    }
    
    static func showAlert(type:Int,title:String,subTitle:String , closeTitle:String)
    {
        if type == Constants.AlertType.AlertError
        {
            SCLAlertView().showError(title, subTitle: subTitle, closeButtonTitle:closeTitle)
        }
        else if type == Constants.AlertType.AlertSuccess
        {
            SCLAlertView().showSuccess(title, subTitle: subTitle , closeButtonTitle:closeTitle)
        }
        else if type == Constants.AlertType.Alertinfo
        {
            SCLAlertView().showInfo(title, subTitle: subTitle , closeButtonTitle:closeTitle)
        }
        else if type == Constants.AlertType.AlertWarn
        {
            SCLAlertView().showWarning(title, subTitle: subTitle , closeButtonTitle:closeTitle)
            
        }
    }
    
    static func saveObjectDefault(key:String,value:Any) {
        do {
            let userDataEncoded = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
            userDef.set(userDataEncoded, forKey: key)
            userDef.synchronize()
        }catch {
            print("archivedData Error")
        }
    }
    
    static func getObjectDefault(key: String) -> Any {
        do {
            if let decodedNSData = UserDefaults.standard.object(forKey: key) as? NSData,
                let Data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decodedNSData as Data) {
                return Data
            }else {
                return ""
            }
        }catch {
            print("Couldn't read file.")
            return ""
        }
    }
    
    static func saveUserDefault(key:String, value:Any) {
        userDef.set(value, forKey: key)
    }
    
    static func getUserDefault(key: String) -> Any {
        return userDef.string(forKey: key) ?? ""
    }
    
    static func removeKeyUserDefault(key: String) {
        userDef.removeObject(forKey: key)
        userDef.synchronize()
    }
    
    static func getCurrentLang() -> String {
        if let lang =  Helper.getUserDefault(key: "language") as? String {
            return lang
        }
        
        return "en"
    }
    
    static func isKeyPresentInUserDefaults(key: String) -> Bool {
        return userDef.object(forKey: key) != nil
    }
    
    
    static func setupSideMenue(nav:UINavigationController) {

        // Define the menus
        let leftMenuNavigationController = SideMenuNavigationController(rootViewController: nav)
        SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController

        let rightMenuNavigationController = SideMenuNavigationController(rootViewController: nav)
        SideMenuManager.default.rightMenuNavigationController = rightMenuNavigationController

        
        leftMenuNavigationController.menuWidth = UIScreen.main.bounds.width - 50
        rightMenuNavigationController.menuWidth = UIScreen.main.bounds.width - 50
        
        leftMenuNavigationController.presentationStyle = .menuSlideIn
        rightMenuNavigationController.presentationStyle = .menuSlideIn


        SideMenuManager.default.addPanGestureToPresent(toView: nav.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: nav.view)

//        leftMenuNavigationController.statusBarEndAlpha = 0
//        rightMenuNavigationController.settings = leftMenuNavigationController.settings
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    static func shareNews(text:String,img:UIImage,vc:UIViewController)
    {
        
        // set up activity view controller
        let Share = [text,img] as [Any]
        let activityViewController = UIActivityViewController(activityItems: Share, applicationActivities: nil
        )
        activityViewController.popoverPresentationController?.sourceView = vc.view // so that iPOffersData won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop ]
        
        // present the view controller
        vc.present(activityViewController, animated: true, completion: nil)
    }
    
    static func shareApp(appUrl:String,vc:UIViewController)
    {
        
        // set up activity view controller
        let url = URL(string: appUrl)
        let Share = [url!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: Share, applicationActivities: nil
        )
        activityViewController.popoverPresentationController?.sourceView = vc.view // so that iPOffersData won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop ]
        
        // present the view controller
        vc.present(activityViewController, animated: true, completion: nil)
    }
    
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    static func animateTable(table:UITableView) {
        table.reloadData()
        
        let cells = table.visibleCells
        let tableHeight: CGFloat = table.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay:  0.05 * Double(index) , usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
    
    static func openScheme(scheme: String) {
        if let url = URL(string: scheme) {
            UIApplication.shared.open(url)
        }
    }
    
    static func openWhatsapp(number: String){
        let trimmedNumber = number.replacingOccurrences(of: " ", with: "")
        print("mobileString trimmed:"+trimmedNumber)

        var whatsappLink: String = ""
        
        if trimmedNumber.prefix(2) == "05" {
            whatsappLink = "https://api.whatsapp.com/send?phone=966\(trimmedNumber)"
        }else {
            whatsappLink = "https://api.whatsapp.com/send?phone=\(trimmedNumber)"
        }
        
        print("urlWhatsapp", whatsappLink)
        
        if let urlString = whatsappLink.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }else {
                    print("Install Whatsapp")
                    Helper.showFloatAlert(title: "من فضلك قم بتنزيل تطبيق الواتسأب", subTitle: "", type: Constants.AlertType.AlertError)
                }
            }
        }
    }
    
    static func callNumber(number:String) {
        if let phoneCallURL = URL(string: "telprompt://"+number) {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    
    static func ShareItem(name: String, itemImage: String, shareUrl: String, vc: UIViewController) {
        let name = name
        let image = UIImage(named: "logo")
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        
        imageView.image = image
        
        if itemImage != "" {
            imageView.sd_setImage(with: URL(string: itemImage), placeholderImage: image)
        }
                
        let linkString = shareUrl
        let link = NSURL(string: linkString)
        let textShare = [name, linkString, imageView.image as Any, link as Any] as [Any]
        let alert = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = vc.view //to set the source of your alert
            popoverController.sourceRect = CGRect(x: vc.view.bounds.midX, y: vc.view.bounds.maxY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func getImageWithSize(urlStr:String,originalSize:String,updateSize:String)->String
    {//"20x14"
        let flag = urlStr.replacingOccurrences(of: originalSize, with: updateSize, options: .literal, range: nil)
        return flag
    }
    
    static func isValidEmail(mail_address:String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: mail_address)
    }
    
    static func isValidPhone(phone:String) -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phone.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  phone == filtered
    }
    
    static func numberToLocale(number : String, localeIdentifier: String) -> NSNumber? {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: localeIdentifier)
        guard let resultNumber = numberFormatter.number(from: number) else{
            return NSNumber(pointer: number)
        }
        return resultNumber
    }
    
    static func getCountryCode(phone:String) -> String {
        var phoneNumber:String = phone
        if phone.first == "0" {
            phoneNumber =  phone.replacingOccurrences(of: "0", with: "")
        }
        if phone.first == "+" {
            phoneNumber =  phone.replacingOccurrences(of: "+", with: "")
        }
        
        let start = phoneNumber.index(phoneNumber.startIndex, offsetBy: phoneNumber.count - 10)
        let end = phoneNumber.index(phoneNumber.endIndex, offsetBy: 0)
        let range = start..<end
        
        return phoneNumber.substring(with: range)
    }
    
    class func viewControllerHelper<VC: UIViewController>(controller:VC.Type, sbName:String) -> VC {
        let sb = UIStoryboard(name: sbName, bundle: nil)
        let identifier = String(describing: controller.self)
        let vc = sb.instantiateViewController(withIdentifier: identifier) as! VC
        return vc
    }

    
    static func format(phoneNumber sourcePhoneNumber: String) -> String? {
        // Remove any character that is not a number
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        // Check for supported phone number length
        guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
            return nil
        }
        let hasAreaCode = (length >= 10)
        var sourceIndex = 0
        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = "1 "
            sourceIndex += 1
        }
        /*
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return nil
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return nil
        }
        sourceIndex += prefixLength
        
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return nil
        }
        */
        
        return leadingOne //leadingOne + areaCode + prefix + "-" + suffix
    }
 
    
    static public func getTopViewController() -> UIViewController? {
        
        if var topViewController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topViewController.presentedViewController {
                topViewController = presentedViewController
            }
            
            return topViewController
        }
        
        return nil
    }
}

