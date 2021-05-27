//
//  LocationPickerViewController.swift
//  note_avengers_iOS
//
//  Created by Vijay Kumar Sevakula on 2021-05-27.
//

import UIKit
import MapKit
class LocationPickerViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    var locationManager =  CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        determineCurrentLocation()
        // Do any additional setup after loading the view.
    }
    
    var currentLocation: CLLocation?
    func determineCurrentLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
    func getAddress(location: CLLocation,handler: @escaping (String) -> Void)
    {
        self.currentLocation = location
        let geoCoder = CLGeocoder()
    
        geoCoder.reverseGeocodeLocation(location, completionHandler:
        { (placemarks, error) -> Void in
            if let placemarks = placemarks
            {
                let pm = placemarks as [CLPlacemark]
                if pm.count > 0
                {
                    let pm = placemarks[0]
                  
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    
                    handler(addressString)
                }
                
            }
           
            
            
            
           // Passing address back
          
        })
    }
    
    
    

}


extension  LocationPickerViewController : MKMapViewDelegate, CLLocationManagerDelegate{
    
}
