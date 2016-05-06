//
//  PostInfoViewController.swift
//  On The Map
//
//  Created by Erick Manrique on 4/26/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import UIKit
import MapKit

class PostInfoViewController: UIViewController, MKMapViewDelegate {

    // MARK: Outlets
    @IBOutlet weak var linkTextView: UITextView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchText: UITextView!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var annotation: MKPointAnnotation!
    var user: Student?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText.delegate = self
        linkTextView.delegate = self
        user = NetworkClient.sharedInstance().user
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func submitPressed(sender: AnyObject) {
        print(searchText.text)
        print(linkTextView.text)
        user?.mediaURL = linkTextView.text
        NetworkClient.sharedInstance().user = user
        
        NetworkClient.sharedInstance().postLocation(user!) { (success, error) in
            if error != nil{
                print(error)
                performUIUpdatesOnMain({
                    let alert = self.basicAlert("Post Location Fail", message: error!.localizedDescription, action: "OK")
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
            if success{
                StudentsArray.students.removeAll()
                self.dismissCurrentVC()
            }
        }
        
    }
    
    @IBAction func findPressed(sender: AnyObject) {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchText.text
        let locationSearch = MKLocalSearch(request: localSearchRequest)
        locationSearch.startWithCompletionHandler { (response, error) in
            guard error == nil else{
                performUIUpdatesOnMain({
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    let alert = self.basicAlert("Warning", message: "Place not found", action: "OK")
                    self.presentViewController(alert, animated: true, completion: nil)
                })
                return
            }
            guard let response = response else{
                performUIUpdatesOnMain({
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    let alert = self.basicAlert("Warning", message: "Place not found", action: "OK")
                    self.presentViewController(alert, animated: true, completion: nil)
                })
                return
            }
            performUIUpdatesOnMain({
                self.bottomView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.4)
                self.topView.hidden = true
                self.searchText.hidden = true
            })
            let lat = response.boundingRegion.center.latitude
            let long = response.boundingRegion.center.longitude
            
            self.user?.latitude = lat
            self.user?.longitude = long
            self.user?.mapString = self.searchText.text
            
            NetworkClient.sharedInstance().user = self.user
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            self.annotation = MKPointAnnotation()
            self.annotation.coordinate = coordinate
            self.mapView.centerCoordinate = self.annotation.coordinate
            self.mapView.addAnnotation(self.annotation)
            self.mapView.region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpanMake(0.01, 0.01))
            performUIUpdatesOnMain({
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.cancelButton.backgroundColor = Constants.UI.BlueColor
                self.cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                self.findButton.hidden = true
                self.submitButton.hidden = false
            })
            
        }
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        dismissCurrentVC()
    }
    
    // MARK: - Methods
    func setup(){
        submitButton.hidden = true
        activityIndicator.hidden = true
    }
    
    private func basicAlert(tittle:String, message:String, action: String)-> UIAlertController{
        let alert = UIAlertController(title: tittle, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: action, style: .Default, handler: nil)
        alert.addAction(action)
        return alert
    }
    
    func dismissCurrentVC(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }

}

// MARK: - PostInfoViewController: UITexViewDelegate
extension PostInfoViewController: UITextViewDelegate{
    func textViewDidBeginEditing(textView: UITextView) {
        if textView == searchText || textView == linkTextView{
            textView.text = ""
        }
    }
}
