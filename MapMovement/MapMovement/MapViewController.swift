//
//  MapViewController.swift
//  MapMovement
//
//  Created by Rory Yang on 1/13/21.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let annotation = MKPointAnnotation()
    let manager = CLLocationManager()
    let userDefaults = UserDefaults()
    let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
    
    var latitude = 0.0
    var longitude = 0.0
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (userDefaults.value(forKey: "longitude") as? Double == nil) {
            
            if (latitude == 0.0 && longitude == 0.0) {
                manager.desiredAccuracy = kCLLocationAccuracyBest
                manager.delegate = self
                manager.requestWhenInUseAuthorization()
                manager.startUpdatingLocation()
            }
            
        } else {
            latitude = userDefaults.value(forKey: "latitude") as! Double
            longitude = userDefaults.value(forKey: "longitude") as! Double
            move()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            getCurrentLocation(location)
        }
    }
    
    func getCurrentLocation(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        let currentLocation = MKPointAnnotation()

        currentLocation.coordinate = coordinate
        currentLocation.title = "Lat: \(Int(location.coordinate.latitude)) Long: \(Int(location.coordinate.longitude))"

        longitude = coordinate.longitude
        userDefaults.setValue(longitude, forKey: "longitude")
        latitude = coordinate.latitude
        userDefaults.setValue(latitude, forKey: "latitude")

        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(currentLocation)
    }
    
    func move() {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        let currentLocation = MKPointAnnotation()

        currentLocation.coordinate = coordinate
        currentLocation.title = "Lat: \(Int(latitude)) Long: \(Int(longitude))"
        
        userDefaults.setValue(longitude, forKey: "longitude")
        userDefaults.setValue(latitude, forKey: "latitude")

        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(currentLocation)
    }
    
    @IBAction func moveNorthButton(_ sender: UIButton) {
        latitude += 0.5
        move()
    }
    
    @IBAction func moveSouthButton(_ sender: UIButton) {
        latitude -= 0.5
        move()
    }
    
    @IBAction func moveWestButton(_ sender: UIButton) {
        longitude -= 0.5
        move()
    }
    
    @IBAction func moveEastButton(_ sender: UIButton) {
        longitude += 0.5
        move()
    }
}
