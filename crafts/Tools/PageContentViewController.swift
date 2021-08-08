//
//  PageContentViewController.swift
//  LibyaApp
//
//  Created by AL Badr  on 8/5/18.
//  Copyright © 2018 AL Badr . All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class PageContentViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var AdImages: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    
    var imageIndex: Int = 0
    var imageURL: String = ""
    var image: UIImage?
    
    var gestureRecognizer: UITapGestureRecognizer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AdImages.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "logo"))
//        AdImages.image = image!
        
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 2.0
        
        setupGestureRecognizer()
    }
    
    func setupGestureRecognizer() {
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        gestureRecognizer.numberOfTapsRequired = 2
        self.AdImages.addGestureRecognizer(gestureRecognizer)
    }
    
    // Handles a double tap by either resetting the zoom or zooming to where was tapped
    @objc func handleDoubleTap() {
        if self.scrollView.zoomScale == 1 {
            self.scrollView.zoom(to: zoomRectForScale(self.scrollView.maximumZoomScale, center: gestureRecognizer.location(in: gestureRecognizer.view)), animated: true)
        } else {
            self.scrollView.setZoomScale(1, animated: true)
        }
    }
    
    // Calculates the zoom rectangle for the scale
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = AdImages.frame.size.height / scale
        zoomRect.size.width = AdImages.frame.size.width / scale
        let newCenter = AdImages.convert(center, from: AdImages)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.AdImages
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
//
//    @IBAction func btnImageShare(_ sender: Any) {
//        let name = "سلعة"
//        let category = "إعلانات"
//        let url = imageURL
//        let link = NSURL(string: url!)
//        let textShare = [name , category , link as Any] as [Any]
//        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view
//        self.present(activityViewController, animated: true, completion: nil)
//    }
    
    @IBAction func btnDownloadButton(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(AdImages.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "خطأ", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "موافق", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "تم!", message: "تم حفظ الصورة", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "موافق", style: .default))
            present(ac, animated: true)
        }
    }
    
    
}
