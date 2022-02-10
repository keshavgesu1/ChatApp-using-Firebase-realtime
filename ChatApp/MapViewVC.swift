//
//  MapViewVC.swift
//  ChatApp
//
//  Created by Keshav Raj Kashyap on 09/02/22.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

@available(iOS 14.0, *)
class MapViewVC: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []

    // The currently selected place.
    var selectedPlace: GMSPlace?
          
//MARK: - CONTROLLER LIFECYLE
    override func viewDidLoad() {
        super.viewDidLoad()
        addMap()
        mapHide()
    }
    
    // Initialize the location manager.
    func addMap(){
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
    }
     
    //hide map until it get the location
    func mapHide(){
        // A default location to use when location permission is not granted.
        let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)

        // Create a map.
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true

        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
              
    }
    
    // Populate the array with the list of likely places.
    func listLikelyPlaces() {
      // Clean up from previous sessions.
      likelyPlaces.removeAll()

      let placeFields: GMSPlaceField = [.name, .coordinate]
      placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { (placeLikelihoods, error) in
        guard error == nil else {
          // TODO: Handle the error.
          print("Current Place error: \(error!.localizedDescription)")
          return
        }

        guard let placeLikelihoods = placeLikelihoods else {
          print("No places found.")
          return
        }

        // Get likely places and add to the list.
        for likelihood in placeLikelihoods {
          let place = likelihood.place
          self.likelyPlaces.append(place)
        }
      }
    }
          
    
}
// Delegates to handle events for the location manager.
@available(iOS 14.0, *)
extension MapViewVC: CLLocationManagerDelegate {

  // Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
    print("Location: \(location)")

    let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                          longitude: location.coordinate.longitude,
                                          zoom: zoomLevel)

    if mapView.isHidden {
      mapView.isHidden = false
      mapView.camera = camera
    } else {
      mapView.animate(to: camera)
    }

    listLikelyPlaces()
  }

  // Handle authorization for the location manager.
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    // Check accuracy authorization
    let accuracy = manager.accuracyAuthorization
    switch accuracy {
    case .fullAccuracy:
        print("Location accuracy is precise.")
    case .reducedAccuracy:
        print("Location accuracy is not precise.")
    @unknown default:
      fatalError()
    }

    // Handle authorization status
    switch status {
    case .restricted:
      print("Location access was restricted.")
    case .denied:
      print("User denied access to location.")
      // Display the map using the default location.
      mapView.isHidden = false
    case .notDetermined:
      print("Location status not determined.")
    case .authorizedAlways: fallthrough
    case .authorizedWhenInUse:
      print("Location status is OK.")
    @unknown default:
      fatalError()
    }
  }

  // Handle location manager errors.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationManager.stopUpdatingLocation()
    print("Error: \(error)")
  }
}
      
