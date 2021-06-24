//
//  AddLocationsVC.swift
//  WeatherApp
//
//  Created by Abhiram Sarvadevabhatla on 24/06/21.
//

import UIKit
import  MapKit
import  CoreLocation

protocol FetchingCitiesDelegate {
    func getCities(cityName : String?)
}

class AddLocationsVC: UIViewController {
    
    
    private let locationManager = CLLocationManager()
    @IBOutlet weak var locationTxtField: UITextField!
    
    var delegate : FetchingCitiesDelegate?
    
    var isFromTextFiledReturn : Bool = false
    
    @IBOutlet weak var searchStackVw: UIStackView!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    @IBAction func addLocationAndDismiss(_ sender: Any) {
        
        if let cityName = self.locationTxtField.text {
            delegate?.getCities(cityName: cityName)
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    func getPlace(for location: CLLocation?,
                     completion: @escaping (CLPlacemark?) -> Void) {
           
        if let lastLocation = location {
                let geocoder = CLGeocoder()
                    
                // Look up the location and pass it to the completion handler
                geocoder.reverseGeocodeLocation(lastLocation,
                            completionHandler: { (placemarks, error) in
                    if error == nil {
                        let firstLocation = placemarks?[0]
                        completion(firstLocation)
                    }
                    else {
                        completion(nil)
                    }
                })
            }
            else {
                completion(nil)
            }
       }
    
    func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?)-> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks,
            let location = placemarks.first?.location?.coordinate else {
                completion(nil)
                return
            }
            completion(location)
        }
    }

}
extension AddLocationsVC : CLLocationManagerDelegate {
    
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            render(location)
        }
    }
    
}
extension AddLocationsVC : MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customAnnotation")
        annotationView.image = UIImage(named: "navigationIcon")
        annotationView.isDraggable = true
        annotationView.canShowCallout = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        
        
        if newState == .ending {
            if let coordinate = view.annotation?.coordinate {
                print("\(coordinate.latitude)---\(coordinate.longitude)")
                
                let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                view.dragState = .none
                getPlace(for: location) { (placemark) in
                    if let cityName = placemark?.locality {
                        print(cityName)
                        self.locationTxtField.text = cityName
                    }
                }
            }
        }
    }
    
    func render(_ location : CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        mapView.setRegion(region, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        
        let locationCord = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        if isFromTextFiledReturn {
            isFromTextFiledReturn = false
            
            
        } else {
            getPlace(for: locationCord) { (placemark) in
                if let cityName = placemark?.locality {
                    self.locationTxtField.text = cityName
                }
            }
        }
        
    }
}
extension AddLocationsVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let locationName = textField.text {
            getLocation(from: locationName) { (coordinate) in
                if let locations = coordinate {
                    print(locations.latitude)
                    print(locations.longitude)
                    let locationCoordinate = CLLocation(latitude: locations.latitude, longitude: locations.longitude)
                    self.isFromTextFiledReturn = true
                    self.render(locationCoordinate)
                }
            }
        }
    }
}
