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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("view will appear")
        getStudents()
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
    
    @IBAction func refreshPressed(sender: AnyObject) {
        StudentsArray.students.removeAll()
        getStudents()
    }

    
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsArray.students.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("MapTableViewCell") as? MapTableViewCell {
            let student = StudentsArray.students[indexPath.row]
            //let student = NetworkClient.sharedInstance().students[indexPath.row]
            cell.configureCell(student.firstName!, studentLastName: student.lastName!, studentLink: student.mediaURL!)
            return cell
        }
        else{
            return MapTableViewCell()
        }
    }
    // MARK: - Table view delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        openUserLink(StudentsArray.students[indexPath.row])
    }
    // MARK: - Methods
    func getStudents(){
        if StudentsArray.students.isEmpty{
            NetworkClient.sharedInstance().getStudentLocations { (success, students, error) in
                if success{
                    if let students = students{
                        StudentsArray.students = students
                        performUIUpdatesOnMain({ 
                            self.tableView.reloadData()
                        })
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
    func openUserLink(student:Student){
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: student.mediaURL!)!)
    }
    
    private func basicAlert(tittle:String, message:String, action: String)-> UIAlertController{
        let alert = UIAlertController(title: tittle, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: action, style: .Default, handler: nil)
        alert.addAction(action)
        return alert
    }
}
