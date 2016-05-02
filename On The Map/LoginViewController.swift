//
//  LoginViewController.swift
//  On The Map
//
//  Created by Erick Manrique on 4/17/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    // MARK: Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var keyboardOnScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        subscribeToNotification(UIKeyboardWillShowNotification, selector: Constants.Selectors.KeyboardWillShow)
        subscribeToNotification(UIKeyboardWillHideNotification, selector: Constants.Selectors.KeyboardWillHide)
        subscribeToNotification(UIKeyboardDidShowNotification, selector: Constants.Selectors.KeyboardDidShow)
        subscribeToNotification(UIKeyboardDidHideNotification, selector: Constants.Selectors.KeyboardDidHide)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setUIEnabled(true)
    }
    
    // MARK: Actions
    
    @IBAction func signUp(sender: AnyObject) {
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: Constants.Udacity.SignUpLink)!)
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            let alert = self.basicAlert("Login Failed", message: "Username or Password is Empty.", action: "OK")
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            setUIEnabled(false)
            NetworkClient.sharedInstance().loginWithUserInfo(usernameTextField.text!, password: passwordTextField.text!) { (success, error) in
                if error != nil{
                    performUIUpdatesOnMain({ 
                        let alert = self.basicAlert("Login Failed", message: "Account not found or invalid credentials.", action: "OK")
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
                if success{
                    NetworkClient.sharedInstance().getUsersPublicData(NetworkClient.sharedInstance().accountKey!, completionHandlerForUserData: { (success, error) in
                        if success{
                            performUIUpdatesOnMain({
                                self.completeLogin()
                            })
                        }
                        else{
                            print(error)
                            performUIUpdatesOnMain({
                                let alert = self.basicAlert("Login Failed", message: "Could not get user info", action: "OK")
                                self.setUIEnabled(true)
                                self.presentViewController(alert, animated: true, completion: nil)
                            })
                        }
                    })
                }
                else{
                    print(error)
                    performUIUpdatesOnMain({ 
                        let alert = self.basicAlert("Login Failed", message: "Invalid username/password", action: "OK")
                        self.setUIEnabled(true)
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
            }
        }
    }
    
    private func completeLogin() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier(Constants.Segue.TabBarController) as! UITabBarController
        presentViewController(controller, animated: true, completion: nil)
    }
    private func basicAlert(tittle:String, message:String, action: String)-> UIAlertController{
        let alert = UIAlertController(title: tittle, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: action, style: .Default, handler: nil)
        alert.addAction(action)
        return alert
    }
}

// MARK: - LoginViewController: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        keyboardOnScreen = true
    }
    
    func keyboardDidHide(notification: NSNotification) {
        keyboardOnScreen = false
    }
    
    private func keyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
}

// MARK: - LoginViewController (Configure UI)

extension LoginViewController {
    
    private func setUIEnabled(enabled: Bool) {
        usernameTextField.enabled = enabled
        passwordTextField.enabled = enabled
        loginButton.enabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    private func configureUI() {
        // configure background gradient
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [Constants.UI.LoginColorTop, Constants.UI.LoginColorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
        configureTextField(usernameTextField)
        configureTextField(passwordTextField)
    }
    
    private func configureTextField(textField: UITextField) {
        let textFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0)
        let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
        textField.leftView = textFieldPaddingView
        textField.leftViewMode = .Always
        textField.backgroundColor = Constants.UI.OrangeLightColor
        textField.textColor = Constants.UI.OrangeColor
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        textField.tintColor = Constants.UI.OrangeColor
        textField.delegate = self
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - LoginViewController (Notifications)

extension LoginViewController {
    
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}



