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

    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitPressed(sender: AnyObject) {
        bottomView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)
        searchText.hidden = true
    }


}
