//
//  MapViewController.swift
//  On The Map
//
//  Created by Erick Manrique on 4/21/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getStudents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogoutPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        NetworkClient.sharedInstance().logoutUser { (success, error) in
            if success{
                performUIUpdatesOnMain({ 
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
            else{
                performUIUpdatesOnMain({
                    let alert = self.basicAlert("Warning", message: "failed to logout user", action: "OK")
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func refreshPressed(sender: AnyObject) {
        NetworkClient.sharedInstance().students.removeAll()
        getStudents()
    }
    
    // MARK: - Map View delegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    // MARK: - Methods
    func getStudents(){
        if NetworkClient.sharedInstance().students.isEmpty{
            NetworkClient.sharedInstance().getStudentLocations { (success, students, error) in
                if success{
                    print("getStudentLocations worked")
                    if let students = students{
                        NetworkClient.sharedInstance().students = students
                        
                        var annotations = [MKPointAnnotation]()
                        for student in NetworkClient.sharedInstance().students {
                            let lat = CLLocationDegrees(student.latitude!)
                            let long = CLLocationDegrees(student.longitude!)
                            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                            
                            let first = student.firstName!
                            let last = student.lastName!
                            let mediaURL = student.mediaURL!
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = coordinate
                            annotation.title = "\(first) \(last)"
                            annotation.subtitle = mediaURL
                            annotations.append(annotation)
                        }
                        self.mapView.addAnnotations(annotations)
                    }
                }
                else{
                    performUIUpdatesOnMain({
                        let alert = self.basicAlert("Warning", message: "Locations not found", action: "OK")
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
            }
        }
    }
    
    private func basicAlert(tittle:String, message:String, action: String)-> UIAlertController{
        let alert = UIAlertController(title: tittle, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: action, style: .Default, handler: nil)
        alert.addAction(action)
        return alert
    }
}
