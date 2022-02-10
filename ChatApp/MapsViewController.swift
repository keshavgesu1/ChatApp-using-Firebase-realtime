//
//  ViewController.swift
//  ChatApp
//
//  Created by Keshav Raj Kashyap on 21/01/22.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Firebase
import FirebaseCrashlytics

class MapsViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,UITextFieldDelegate {
    @IBOutlet weak var txtSearchLocation: UITextField!
    @IBOutlet weak var lblLocationName: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var zoom: Float = 15
    var geocoder = CLGeocoder()
    let marker = GMSMarker()

    //MARK: CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearchLocation.delegate = self
        self.navigationController?.navigationBar.isHidden = false
        mapType()
        mapUtils()
       
    }
    
    //zoom map
    @IBAction func btnZoomIn(_ sender: Any) {
        zoom = zoom + 1
        self.mapView.animate(toZoom: zoom)
    }
    
    @IBAction func btnZoomOut(_ sender: Any) {
        zoom = zoom - 1
        self.mapView.animate(toZoom: zoom)
    }
    
    //MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchPlaceFromGoogle(place: textField.text!)
        return true
    }
    
    func searchPlaceFromGoogle(place:String) {
    var strGoogleApi = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(place)&key=AIzaSyDIgN5-EiFsLEojuoxzkKbsJp6ayZnIONA"
        strGoogleApi = strGoogleApi.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        var urlRequest = URLRequest(url: URL(string: strGoogleApi)!)
        urlRequest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, resopnse, error) in
            if error == nil {
                let jsonDict = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                print("json == \(String(describing: jsonDict))")
            } else {
                //we have error connection google api
            }
        }
        task.resume()
    }
    
    //handle maps method
    func mapUtils(){
        txtSearchLocation.delegate = self
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.distanceFilter = 10
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
    }
    
    //added method to choose map type
    func mapType(){
        mapView.settings.myLocationButton = true
        let actionSheet = UIAlertController(title: "Map Types", message: "Select map type:", preferredStyle: UIAlertController.Style.actionSheet)
        
        let normalMapTypeAction = UIAlertAction(title: "Normal", style: UIAlertAction.Style.default) { (alertAction) -> Void in
            self.mapView.mapType = .terrain
        }
        
        let terrainMapTypeAction = UIAlertAction(title: "Terrain", style: UIAlertAction.Style.default) { (alertAction) -> Void in
            self.mapView.mapType = .normal
        }
        
        let hybridMapTypeAction = UIAlertAction(title: "Hybrid", style: UIAlertAction.Style.default) { (alertAction) -> Void in
            self.mapView.mapType = .hybrid
        }
        
        let cancelAction = UIAlertAction(title: "Close", style: UIAlertAction.Style.cancel) { (alertAction) -> Void in
            
        }
        actionSheet.addAction(normalMapTypeAction)
        actionSheet.addAction(terrainMapTypeAction)
        actionSheet.addAction(hybridMapTypeAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.isMyLocationEnabled = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        locationManager.distanceFilter = 5
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)

        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 15);
        self.mapView.camera = camera
        self.mapView.isMyLocationEnabled = true

      //  let marker = GMSMarker(position: center)
        print("Latitude :- \(userLocation!.coordinate.latitude)")
        print("Longitude :-\(userLocation!.coordinate.longitude)")
      //  marker.map = self.mapView
       // marker.title = "Current Location"
        locationManager.stopUpdatingLocation()
    }
    

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let locationName = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(locationName){ placemarks, error in
            guard let placemark = placemarks?.first else {
                let errorString = error?.localizedDescription ?? "Unexpected Error"
                print("Unable to reverse geocode the given location. Error: \(errorString)")
                return
            }
            let reversedGeoLocation = ReversedGeoLocation(with: placemark)
            print(reversedGeoLocation.formattedAddress)
            // Creates a marker in the center of the map.
            self.marker.icon = GMSMarker.markerImage(with: UIColor.blue)
            self.marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.marker.title = (reversedGeoLocation.streetNumber  + "," + reversedGeoLocation.streetName + "," + reversedGeoLocation.state + "," + reversedGeoLocation.zipCode)
            self.marker.snippet = reversedGeoLocation.country
            self.marker.map = mapView
            mapView.selectedMarker = self.marker
            self.lblLocationName.text = reversedGeoLocation.formattedAddress
        }
        
    }
}



//by this method we get only city and country
extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}
//by this method we get only city and country
/*   locationName.fetchCityAndCountry { city, country, error in
 guard let city = city, let country = country, error == nil else { return }
 print(city + ", " + country)  // Rio de Janeiro, Brazil
 self.lblLocationName.text = (city + ", " + country)
 }*/


extension MapsViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
      print("Place name: \(String(describing: place.name))")
      print("Place address: \(String(describing: place.formattedAddress))")
      print("Place attributions: \(String(describing: place.attributions))")
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: \(error)")
    dismiss(animated: true, completion: nil)
  }

  // User cancelled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    print("Autocomplete was cancelled.")
    dismiss(animated: true, completion: nil)
  }
}
