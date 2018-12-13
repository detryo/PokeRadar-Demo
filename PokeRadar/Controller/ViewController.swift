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
import FirebaseDatabase

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapCentered = false
    var geoFire : GeoFire!
    var geoFireRef: DatabaseReference!
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.geoFireRef = Database.database().reference()
        self.geoFire = GeoFire(firebaseRef: self.geoFireRef)
        self.mapView.delegate = self
        self.mapView.userTrackingMode = .follow
        self.locationManager.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(notify), name: NSNotification.Name(rawValue: "NotifyPokemon"), object: nil)
        
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
    
    func centerMap(on location: CLLocation){
        let region = MKCoordinateRegion (center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        self.mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if !mapCentered {
            if let location = userLocation.location {
                centerMap(on: location)
                mapCentered = true
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        let location = CLLocation(latitude: self.mapView.centerCoordinate.latitude,
                                 longitude: self.mapView.centerCoordinate.longitude)
        
        self.showSightingsOnMap(on:location)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView : MKAnnotationView?
        let annotationIdentifier = "Pokemon"
        
        if annotation.isKind(of: MKUserLocation.self){
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            
            annotationView?.image = #imageLiteral(resourceName: "characters")
            
        }else if let dequeuedAnnotation = self.mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotation
            annotationView?.annotation = annotation
            
        }else {
            annotationView = MKAnnotationView(annotation: annotation,
                                              reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView,
           let pokemonAnnotation = annotation as? PokemonAnnotation {
            
            annotationView.canShowCallout = true
            annotationView.image = pokemonAnnotation.pokemon.image
            
            let button = UIButton()
            button.frame  = CGRect(x: 0, y: 0, width: 30, height: 30)
            button.setImage(#imageLiteral(resourceName: "location-map-flat"), for: .normal)
            annotationView.rightCalloutAccessoryView = button
        }
        return annotationView
    }
    
    func createSighting(forLocation location: CLLocation, with pokemonId: Int){
        
        self.geoFire.setLocation(location, forKey: "\(pokemonId)")
    }
    
    func showSightingsOnMap(on location:CLLocation){
        let query = self.geoFire.query(at: location, withRadius: 2.0)
        
        query.observe(.keyEntered, with: { (key, location) in
            
            let annotation = PokemonAnnotation(coordinate: location.coordinate, pokemonId: Int(key)!)
            self.mapView.addAnnotation(annotation)
            
        })
    }

    @IBAction func reportPokemon(_ sender: UIButton) {
        
        let location = CLLocation(latitude: self.mapView.centerCoordinate.latitude,
                                 longitude: self.mapView.centerCoordinate.longitude)
        
        let pokemonIdRand = arc4random_uniform(151) + 1
        self.createSighting(forLocation: location, with: Int(pokemonIdRand))
    }
    
    @objc func notify(notify: Notification){
        
        if let pokemon = notify.object as? Pokemon {
            
            let location = CLLocation(latitude:  self.mapView.centerCoordinate.latitude,
                                      longitude: self.mapView.centerCoordinate.longitude)
            
            self.createSighting(forLocation: location, with: pokemon.id)
        }
    }
}

