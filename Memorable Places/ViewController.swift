//
//  ViewController.swift
//  Memorable Places
//
//  Created by Richard Guerci on 19/09/2015.
//  Copyright © 2015 Richard Guerci. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
	
	var mapManager: CLLocationManager!

	@IBOutlet weak var map: MKMapView!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//initialize LocationManager
		mapManager = CLLocationManager()
		mapManager.delegate = self
		mapManager.desiredAccuracy = kCLLocationAccuracyBest
		
		if placeIndex == -1 { //only start updating location when required
			mapManager.requestWhenInUseAuthorization()
			mapManager.startUpdatingLocation()
			
		} else {
			//Coordinate
			let latitude = NSString(string: places[placeIndex]["latitude"]!).doubleValue
			let longitude = NSString(string: places[placeIndex]["longitude"]!).doubleValue
			let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
			//Zoom
			let latDelta:CLLocationDegrees = 0.01
			let lonDelta:CLLocationDegrees = 0.01
			let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
			//Create region
			let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
			self.map.setRegion(region, animated: true)
			
			//place an anotation at the coordinate position
			let annotation = MKPointAnnotation()
			annotation.coordinate = coordinate
			annotation.title = places[placeIndex]["name"]
			map.addAnnotation(annotation)
			
		}
		
		//Add a gesture recocognizer for long press
		let gesture = UILongPressGestureRecognizer(target: self, action: "actionLongPress:")
		gesture.minimumPressDuration = 2.0
		map.addGestureRecognizer(gesture)

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func actionLongPress(gestureRecognizer:UIGestureRecognizer) {
		
		if gestureRecognizer.state == UIGestureRecognizerState.Began {
			let touchPoint = gestureRecognizer.locationInView(self.map)
			//Convert touchPoint to map coordinate
			let newCoordinate = map.convertPoint(touchPoint, toCoordinateFromView: map)
			let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
			
			//Get name of the touched location
			CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
				var title = ""
				if (error == nil) {
					//if statement was changed
					if let p = placemarks?[0] {
						var subThoroughfare:String = ""
						var thoroughfare:String = ""
						if p.subThoroughfare != nil {
							subThoroughfare = p.subThoroughfare!
						}
						if p.thoroughfare != nil {
							thoroughfare = p.thoroughfare!
						}
						title = "\(subThoroughfare) \(thoroughfare)"
					}
				}
				
				if title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "" {
					title = "Added \(NSDate())"
				}
				
				places.append(["name":title,"latitude":"\(newCoordinate.latitude)","longitude":"\(newCoordinate.longitude)"])
				NSUserDefaults.standardUserDefaults().setObject(places, forKey: "places")

				let annotation = MKPointAnnotation()
				annotation.coordinate = newCoordinate
				annotation.title = title
				self.map.addAnnotation(annotation)
			})
		}
	}
	
	//Called every time the location is updated
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		//Get the location
		let userLocation:CLLocation = locations[0]
		let coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
		let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
		let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
		map.setRegion(region, animated: true)
		
		mapManager.stopUpdatingLocation()
	}


}

