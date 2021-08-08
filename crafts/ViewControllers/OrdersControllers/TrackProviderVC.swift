//
//  TrackProviderVC.swift
//  salon
//
//  Created by AL Badr  on 6/30/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class TrackProviderVC: UIViewController {

    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!

    var placeLat: String = ""
    var placeLon: String = ""
    var providerId: String = ""
    
    let locationManager = CLLocationManager()

    fileprivate var placeLoc:CLLocationCoordinate2D?
    fileprivate var userLoc:CLLocationCoordinate2D?
    
    var ref: DatabaseReference?
    
    override func viewWillAppear(_ animated: Bool) {
        addAnnotation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        ref = Database.database().reference()

    }
    
    func addAnnotation() {
        // Add annotation:
        let allAnnotations = mapKit.annotations
        self.mapKit.removeAnnotations(allAnnotations)
        
        let providerPlace = CLLocation(latitude: Double(placeLat) ?? 0, longitude: Double(placeLon) ?? 0)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = providerPlace.coordinate
        
        placeLoc = annotation.coordinate

        mapKit.addAnnotation(annotation)
        
        print("annotation lat: ", placeLoc?.latitude ?? 0.0)
        print("annotation lon: ", placeLoc?.longitude ?? 0.0)
        
        if userLoc != nil {
            getDistance()
        }
    }
    
    func getProviderLocation() {
        ref?.child("location").child(providerId).observe(.value, with: { (snapshot) in
            guard let liveLocation = (snapshot.value as? UserLiveLocation) else { return }
            
            self.placeLat = liveLocation.lat
            self.placeLon = liveLocation.lon
            
            self.addAnnotation()
        })
    }
    
    func getDistance() {
        let providerPlace = CLLocation(latitude: Double(placeLat) ?? 0, longitude: Double(placeLon) ?? 0)
        let userPlace = CLLocation(latitude: userLoc?.latitude ?? 0, longitude: userLoc?.longitude ?? 0)

        let distance = providerPlace.distance(from: userPlace)
        let kmDistance = (distance / 1000).rounded(toPlaces: 2)
        
        distanceLabel.text = String (kmDistance)
    }
    
    @IBAction func backBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
 

}

extension TrackProviderVC : CLLocationManagerDelegate {
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
            
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: userLoc!, span: span)
            mapKit.setRegion(region, animated: true)
            
            getDistance()
            
        }else{
            print("location:: (Not Defined)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}
