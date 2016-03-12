//
//  LocationsViewController.swift
//  Banking With Biometrics
//
//  Created by Navpreet Brar on 2016-03-10.
//  Copyright © 2016 319ProjectTeam4. All rights reserved.
//

import UIKit
import MapKit

class LocationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var clLocations: [CLLocation] = []
    var locationNames: [String] = []
    
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        initLocationData()
        var initialLocation = CLLocation(latitude: 49.1833, longitude: -122.8500)
        if clLocations.count > 0 {
            initialLocation = clLocations[0]
        }
        centerMapOnLocation(initialLocation)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        cell.textLabel?.text = locationNames[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        centerMapOnLocation(clLocations[indexPath.row])
    }
    
    func initLocationData(){
        let path = NSBundle.mainBundle().pathForResource("MockData", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let locations = dict!.valueForKey("Locations") as! NSArray
        for location in locations {
            let locationDict = location as! NSDictionary
            let locationName = locationDict.valueForKey("Name") as! String
            locationNames.append(locationName)
            let lat = locationDict.valueForKey("Lat") as! NSNumber
            let long = locationDict.valueForKey("Long") as! NSNumber
            clLocations.append(CLLocation(latitude: lat.doubleValue, longitude: long.doubleValue))
            addPinToMap(locationName, latitude: lat.doubleValue, longitude: long.doubleValue)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addPinToMap(name: String, latitude: Double, longitude: Double) {
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        // Drop a pin
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = location
        dropPin.title = name
        mapView.addAnnotation(dropPin)
    }
    
}
