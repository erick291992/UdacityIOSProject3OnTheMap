//
//  MapTableViewController.swift
//  On The Map
//
//  Created by Erick Manrique on 4/24/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import UIKit

class MapTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        print("Number Of Students \(NetworkClient.sharedInstance().students.count)")
        getStudents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        
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
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NetworkClient.sharedInstance().students.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("MapTableViewCell") as? MapTableViewCell {
            let student = NetworkClient.sharedInstance().students[indexPath.row]
            cell.configureCell(student.firstName, studentLastName: student.lastName, studentLink: student.mediaURL)
            return cell
        }
        else{
            return MapTableViewCell()
        }
    }
    // MARK: - Table view delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        openUserLink(NetworkClient.sharedInstance().students[indexPath.row])
    }
    
    func getStudents(){
        if NetworkClient.sharedInstance().students.isEmpty{
            NetworkClient.sharedInstance().getStudentLocations { (success, students, error) in
                if success{
                    print("getStudentLocations worked")

                }
                else{
                    print("getStudentLocations did not work")
                }
            }
        }
    }
    func openUserLink(student:Student){
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: student.mediaURL)!)
    }
}
