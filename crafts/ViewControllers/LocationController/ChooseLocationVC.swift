//
//  ChooseLocationVC.swift
//  salon
//
//  Created by AL Badr  on 6/16/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces

class ChooseLocationVC: UIViewController {

    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var locatedAddress: UILabel!
    @IBOutlet weak var locationsView: UIView!
    @IBOutlet weak var placesCV: UICollectionView!
    
    var placesList: [LocationsModel] = []
    
    fileprivate var presenter: PlacesPresenter?
    
    fileprivate var placeLoc:CLLocationCoordinate2D?
    fileprivate var userLoc:CLLocationCoordinate2D?

    fileprivate var selectedPin:MKPlacemark? = nil
    
    fileprivate var resultSearchController: UISearchController? = nil

    let locationManager = CLLocationManager()

    var placeTitle: String = ""
    var placeLat: String = ""
    var placeLon: String = ""

    var newPlace: Bool = false
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        placesCV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        resultSearchController = UISearchController(searchResultsController: nil)
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for place".localiz()
        searchBar.delegate = self

        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let gestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleMapTap))
        mapKit.addGestureRecognizer(gestureRecognizer)
        
        if newPlace {
            locationsView.isHidden = true
        }else {
            locationsView.isHidden = false
            
            initView()
            showPlaces()
        }
    }
    
    func initView() {        
        placesCV.dataSource = self
        placesCV.delegate = self
        placesCV.register(UINib(nibName: "LocationsCell", bundle: nil), forCellWithReuseIdentifier: "LocationsCell")
    }
    
    func showPlaces() {
        presenter = PlacesPresenter(self)
        presenter?.getPlaces()
    }
    
    @IBAction func chooseLocation_tapped(_ sender: UIButton) {
        var objectInfo = [String: String]()
        
        placeLat = "\(placeLoc?.latitude ?? 0.0)"
        placeLon = "\(placeLoc?.longitude ?? 0.0)"

        objectInfo["lat"] = placeLat
        objectInfo["lon"] = placeLon
        objectInfo["placeTitle"] = placeTitle

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "locationNotification"), object: nil, userInfo: objectInfo)
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleMapTap(gestureReconizer: UILongPressGestureRecognizer) {
        
        let location = gestureReconizer.location(in: mapKit)
        let coordinate = mapKit.convert(location,toCoordinateFrom: mapKit)
        
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        placeLoc = annotation.coordinate
        
        let allAnnotations = mapKit.annotations
        self.mapKit.removeAnnotations(allAnnotations)
 
        mapKit.addAnnotation(annotation)
        
        print("annotation lat: ", placeLoc?.latitude ?? 0.0)
        print("annotation lon: ", placeLoc?.longitude ?? 0.0)
        
        getPlaceName(loc: placeLoc)

        annotation.title =  placeTitle
    }
    
    func getPlaceName(loc:CLLocationCoordinate2D?) {
        let place = CLLocation(latitude: loc?.latitude ?? 0.0, longitude: loc?.longitude ?? 0.0)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(place, completionHandler: { (placemarks, error) -> Void in
            // Place details
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            // Address dictionary
            print("place Name", placeMark?.name ?? "")
            self.placeTitle = placeMark?.name ?? ""
            self.placeLat = "\(loc?.latitude ?? 0.0)"
            self.placeLon = "\(loc?.longitude ?? 0.0)"
            self.locatedAddress.text = placeMark?.name ?? ""
        })
    }

}

extension ChooseLocationVC: GMSAutocompleteViewControllerDelegate, UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        acController.modalPresentationStyle = .fullScreen
        present(acController, animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = place.coordinate
        annotation.title = place.name
        
        placeLoc = annotation.coordinate
        
        placeTitle = place.name ?? ""
        locatedAddress.text = place.name ?? ""

        
        placeLat = "\(placeLoc?.latitude ?? 0.0)"
        placeLon = "\(placeLoc?.longitude ?? 0.0)"
        
        print("annotation lat: ", placeLat)
        print("annotation lon: ", placeLon)
        
        mapKit.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: place.coordinate, span: span)
        mapKit.setRegion(region, animated: true)
        
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
}

extension ChooseLocationVC : CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            print("location: ", locations.last?.coordinate.latitude ?? 0.0)
            print("location: ", locations.last?.coordinate.longitude ?? 0.0)
            
            userLoc = locations.last?.coordinate
            placeLoc = userLoc
            getPlaceName(loc: placeLoc)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: userLoc!, span: span)
            mapKit.setRegion(region, animated: true)
            
        }else{
            print("location:: (Not Defined)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}

extension ChooseLocationVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return placesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationsCell", for: indexPath) as?
            LocationsCell else {
                return UICollectionViewCell()
        }
        
        cell.configCell(item: placesList[indexPath.row])
        
        cell.deleteBtn.isHidden = true
        
        cell.chooseRadioBtn.addTarget(self, action: #selector(ShowDeleteDialog(_:)), for: UIControl.Event.touchUpInside)
        cell.chooseRadioBtn.tag = indexPath.row
        
        return cell
    }
    
    @objc func ShowDeleteDialog(_ sender: UIButton) {
        for i in 0..<placesList.count {
            guard let cell = placesCV.cellForItem(at: IndexPath(row: i, section: 0)) as? LocationsCell else { return }
            i == sender.tag ? cell.setSelected(selected: true) : cell.setSelected(selected: false)
        }

        placeTitle = placesList[sender.tag].place_title ?? ""
        placeLat = placesList[sender.tag].place_lat ?? ""
        placeLon = placesList[sender.tag].place_lon ?? ""
        
        let selectedPlace = CLLocation(latitude: Double(placeLat) ?? 0, longitude: Double(placeLon) ?? 0)

        let annotation = MKPointAnnotation()
        annotation.coordinate = selectedPlace.coordinate
        annotation.title = placeTitle
        
        placeLoc = annotation.coordinate
    
        locatedAddress.text = placeTitle
        
        mapKit.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: selectedPlace.coordinate, span: span)
        mapKit.setRegion(region, animated: true)
    }
    
}

extension ChooseLocationVC: PlacesPresenterView {
    func getPlacesSuccess(_ response: [LocationsModel]) {
        placesList = response
        placesCV.reloadData()
    }
    
    func getPlacesFailure() {
        locationsView.isHidden = true
    }
    
    func getAddPlaceSuccess() {}
    
    func getAddPlaceFailure() {}
    
    func getRemovePlaceSuccess() {}
    
    func getRemovePlaceFailure() {}

    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}

