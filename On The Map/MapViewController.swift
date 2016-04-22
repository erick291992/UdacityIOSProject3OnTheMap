//
//  MapViewController.swift
//  On The Map
//
//  Created by Erick Manrique on 4/21/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
