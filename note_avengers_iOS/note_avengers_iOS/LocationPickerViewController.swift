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
    let newPin = MKPointAnnotation()
    var locationManager =  CLLocationManager()
    @IBOutlet weak var addressLabel: UILabel!
    
    var currentLocation: CLLocation?
    var savedLocation : Location?
    override func viewDidLoad() {
        super.viewDidLoad()
        determineCurrentLocation()
        // Do any additional setup after loading the view.
    }
    
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


extension  LocationPickerViewController : MKMapViewDelegate,CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.removeAnnotation(newPin)
        let location = locations.last! as CLLocation
        self.getAddress(location: location) { (address) in
            self.addressLabel.text = address
            
            print(address)
        }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        
        mapView.setRegion(region, animated: true)
        
       
        if let loc = savedLocation{
            if let coordinate = loc.location?.coordinate{
                newPin.coordinate = coordinate
            }
            self.addressLabel.text = loc.fullAddress ?? ""
            
        }else{
            newPin.coordinate = location.coordinate
        }
        mapView.addAnnotation(newPin)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let identifier = "pinAnnotation"
             var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
             if (annotationView == nil) {
                 annotationView = MKPinAnnotationView(annotation: annotation,
                                                      reuseIdentifier: identifier)
                 if let av = annotationView {
                     av.pinTintColor = .red
                     av.animatesDrop = false
                     av.canShowCallout = false
                     av.isDraggable = true
                 } else {
                    // unexpected(error: nil, "Can't create MKPinAnnotationView")
                 }
             } else {
                 annotationView!.annotation = annotation
             }
             return annotationView
        
       // return pav
    }
    

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        
    }

}
