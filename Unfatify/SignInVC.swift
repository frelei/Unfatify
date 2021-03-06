//
//  SignInVC.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 07/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

class SignInVC: UIViewController, UITextFieldDelegate {

    // MARK: CONSTANTS
    
    let titleWarinig = "Unfatfy"
    let messageWarning  = "Invalid parameters to login"
    let messagefieldValidation = "The field need to be at least 5 characters"
    let messageResetEmail = "Check your email, Unfatify send an email to reset your password"
    let messageErrorServer  = "Ops! Server error on sign up, please try again"
    
    var selectedTextField = 0
    var gap = 3.5
    
    // MARK: IBOUTLETS
    @IBOutlet weak var txtUsername: UITextField! {
        didSet{ txtUsername.delegate = self }
    }
    
    @IBOutlet weak var txtPassword: UITextField! {
        didSet { txtPassword.delegate = self }
    }
    
    @IBOutlet weak var activityIndicator: UIView!{
        didSet{
            activityIndicator.hidden = true
            activityIndicator.layer.cornerRadius = 25
        }
    }
    
    
    // MARK: LIFE CYCLE VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    // MARK: KEYBOARD
    func keyboardWillShow(notification: NSNotification){
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size.height
        let size =   Double(keyboardSize!)  *  Double( Double(self.selectedTextField) / self.gap) // Total of UITextFields
        self.view.frame.origin.y = 0
        self.view.frame.origin.y -=  CGFloat(size)
    }
    
    func keyboardWillHide(notification: NSNotification){
        self.view.frame.origin.y = 0
    }
    
    
    // MARK: UITEXTFIELDELEGATE
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.selectedTextField = textField.tag
    }
    
    
    
    // MARK: IBACTIONS
    
    @IBAction func signin(sender: UIButton) {
        // TODO: LOADER
        guard let username = self.txtUsername where self.txtUsername.charactersInRange(5)
                             else {
                                let  alertController = UIAlertController.basicMessage(self.titleWarinig, message: self.messagefieldValidation)
                                self.presentViewController(alertController, animated: true, completion: nil)
                                return
                             }
        guard let password = self.txtPassword where self.txtPassword.charactersInRange(5)
                            else {
                                let  alertController = UIAlertController.basicMessage(self.titleWarinig, message: self.messagefieldValidation)
                                self.presentViewController(alertController, animated: true, completion: nil)
                                return
                            }
        // Start Loader
        self.activityIndicator.hidden = false
        let activity = self.activityIndicator.viewWithTag(1) as! UIActivityIndicatorView
        activity.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let parseAPI = ParseAPI()
        parseAPI.signIn(username.text!, password: password.text!, success: { (data) -> Void in
            let user = User.jsonToUser(data as! [String:AnyObject])
            
            // Synchronize token on keychain
            let keychainService = KeychainService()
            keychainService.setToken(user.sessionToken!)
            
            // save the user token
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
            let calorieVC = navigationController.viewControllers.first as! CalorieVC
            calorieVC.user = user
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            UIView.transitionFromView(self.view, toView: calorieVC.view, duration: 0.5, options: .TransitionFlipFromRight, completion: { (result) -> Void in
                appDelegate.window?.rootViewController = navigationController
                self.activityIndicator.hidden = true
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            })
            
            
            }, failure: { (error) -> Void in
                self.activityIndicator.hidden = false
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                let  alertController = UIAlertController.basicMessage(self.titleWarinig, message: self.messageWarning)
                self.presentViewController(alertController, animated: true, completion: nil)
        })
        
    }
    
    // TODO: Alert
    @IBAction func forgotPassword(sender: UIButton) {
        let alertController = UIAlertController(title: "Unfatify", message: "Forget Password", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Email"
        }
        
        let forgetPasswordAction = UIAlertAction(title: "Send Email", style: .Default)
            { (_) in
                    let loginTextField = alertController.textFields![0] as UITextField
                
                let parseAPI = ParseAPI()
                parseAPI.resetPassword(loginTextField.text!, success: { (data) -> Void in
                    let  alertController = UIAlertController.basicMessage(self.titleWarinig, message: self.messageResetEmail)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    }, failure: { (error) -> Void in
                        let  alertController = UIAlertController.basicMessage(self.titleWarinig, message: self.messageResetEmail)
                        self.presentViewController(alertController, animated: true, completion: nil)
                })
          }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel)
            { (alertAction) -> Void in
            
            }
        
        alertController.addAction(forgetPasswordAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signup(sender: UIButton) {
        self.performSegueWithIdentifier("goToSignUp", sender: nil)
    }


}
