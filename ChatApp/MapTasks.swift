//
//  MapTasks.swift
//  ChatApp
//
//  Created by Keshav Raj Kashyap on 29/01/22.
//
import Foundation
import GoogleMaps
import GooglePlaces

struct ReversedGeoLocation {
    let name: String
    let streetName: String
    let streetNumber: String
    let city: String            
    let state: String
    let zipCode: String
    let country: String
    let isoCountryCode: String

    var formattedAddress: String {
        return """
        \((name) + "," + (streetNumber) + "," + (streetName) + "," +
        (city) + "," + (state) + "," + (zipCode) + "," + (country))
        """
    }

    // Handle optionals as needed
    init(with placemark: CLPlacemark) {
        self.name           = placemark.name ?? ""
        self.streetName     = placemark.thoroughfare ?? ""
        self.streetNumber   = placemark.subThoroughfare ?? ""
        self.city           = placemark.locality ?? ""
        self.state          = placemark.administrativeArea ?? ""
        self.zipCode        = placemark.postalCode ?? ""
        self.country        = placemark.country ?? ""
        self.isoCountryCode = placemark.isoCountryCode ?? ""
    }
}
