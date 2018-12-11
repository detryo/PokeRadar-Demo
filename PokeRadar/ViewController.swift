//
//  ViewController.swift
//  PokeRadar
//
//  Created by Cristian Sedano Arenas on 1/11/18.
//  Copyright © 2018 Cristian Sedano Arenas. All rights reserved.
//

import UIKit
import MapKit
import GeoFire

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var geoFire : GeoFire!
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.mapView.userTrackingMode = .follow
        self.locationManager.delegate = self
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.mapView.showsUserLocation = true
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.mapView.showsUserLocation = true
        }
    }

    @IBAction func reportPokemon(_ sender: UIButton) {
    }
}

