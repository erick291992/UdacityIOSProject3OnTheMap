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
                print("failed to logout user \(error)")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    
    func getStudents(){
        if NetworkClient.sharedInstance().students.isEmpty{
            NetworkClient.sharedInstance().getStudentLocations { (success, students, error) in
                if success{
                    print("getStudentLocations worked")
                    if let students = students{
                        NetworkClient.sharedInstance().students = students
                        
                        var annotations = [MKPointAnnotation]()
                        
                        // The "locations" array is loaded with the sample data below. We are using the dictionaries
                        // to create map annotations. This would be more stylish if the dictionaries were being
                        // used to create custom structs. Perhaps StudentLocation structs.
                        
                        for student in NetworkClient.sharedInstance().students {
                            
                            // Notice that the float values are being used to create CLLocationDegree values.
                            // This is a version of the Double type.
                            let lat = CLLocationDegrees(student.latitude)
                            let long = CLLocationDegrees(student.longitude)
                            
                            // The lat and long are used to create a CLLocationCoordinates2D instance.
                            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                            
                            let first = student.firstName
                            let last = student.lastName
                            let mediaURL = student.mediaURL
                            
                            // Here we create the annotation and set its coordiate, title, and subtitle properties
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = coordinate
                            annotation.title = "\(first) \(last)"
                            annotation.subtitle = mediaURL
                            
                            // Finally we place the annotation in an array of annotations.
                            annotations.append(annotation)
                        }
                        // When the array is complete, we add the annotations to the map.
                        self.mapView.addAnnotations(annotations)
                    }
                }
                else{
                    print("getStudentLocations did not work")
                }
            }
        }
    }
}
