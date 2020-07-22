//
//  LocationViewModel.swift
//  donorsChoose
//
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine
import CoreLocation

class LocationViewModel: NSObject, ObservableObject{
    
    //let objectWillChange = PassthroughSubject<Void, Never>()
    
    //    @Published var someVar: Int = 0 {
    //      willSet { objectWillChange.send() }
    //    }
    
    @Published var status: CLAuthorizationStatus = .notDetermined
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0
    @Published var location: CLLocation?
    @Published var placemark: CLPlacemark?
    //        {
    //      willSet { objectWillChange.send() }
    //    }
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    var locationChangedCallback:(()->())?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        #if os(iOS)
        self.locationManager.requestWhenInUseAuthorization()
        #endif
        
        #if os(macOS)
            // requestWhenInUseAuthorization is not available on macOS
        #endif
        
        self.locationManager.startUpdatingLocation()
    }
}

extension LocationViewModel: CLLocationManagerDelegate {
    
    func calculateDistance( destination: CLLocation ) -> CLLocationDistance?{
        if let currentLocation = self.location {
            let distance = currentLocation.distance(from: destination)
            return distance
        } else {
            return nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        self.userLatitude = location.coordinate.latitude
        self.userLongitude = location.coordinate.longitude
        self.location = location
        geocode()
        //print(location)
        locationChangedCallback?()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
    }
    
    private func geocode() {
        guard let location = self.location else { return }
        geocoder.reverseGeocodeLocation(location, completionHandler: { (places, error) in
            if error == nil {
                self.placemark = places?[0]
            } else {
                self.placemark = nil
            }
        })
    }//end geocode
    
}
