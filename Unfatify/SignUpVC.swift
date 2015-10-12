//
//  SignUpVC.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 07/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController, UITextFieldDelegate {
    
    // MARK: CONSTANTS
    let titleWarinig = "Unfatify"
    let messageErrorServer  = "Ops! Server error on sign up, please try again"
    let messageField = "The field need to be at least 5 characters"
    let messageEmail = "Invalid email"
    
    var selectedTextField = 0
    let gap = 4.0
    
    // MARK: IBOUTLET
    @IBOutlet weak var txtUsername: UITextField!{
        didSet{ txtUsername.delegate = self }
    }
    
    @IBOutlet weak var txtEmail: UITextField!{
        didSet { txtEmail.delegate = self }
    }
    
    @IBOutlet weak var txtPassword: UITextField!{
        didSet { txtPassword.delegate = self }
    }
    
    @IBOutlet weak var txtDailyCalories: UITextField!{
        didSet { txtDailyCalories.delegate = self }
    }
    
    
    // MARK: LIFE CYCLE VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK: TOUCH
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.txtDailyCalories.resignFirstResponder()
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
    
    
    // MARK: IBACTIONS
    
    @IBAction func signUp(sender: UIButton) {
        // Validate Fields
        guard let username = self.txtUsername where self.txtUsername.charactersInRange(5)
            else {
                let  alertController = UIAlertController.basicMessage(self.titleWarinig, message: self.messageField)
                self.presentViewController(alertController, animated: true, completion: nil)
                return
        }
        guard let email = self.txtEmail where (self.txtEmail.text?.containsString("@") != nil)
            else {
                let alertController = UIAlertController.basicMessage(self.titleWarinig, message: self.messageEmail)
                self.presentViewController(alertController, animated: true, completion: nil)
                return
        }
        guard let password = self.txtPassword where self.txtPassword.charactersInRange(5)
            else {
                let  alertController = UIAlertController.basicMessage(self.titleWarinig, message: self.messageField)
                self.presentViewController(alertController, animated: true, completion: nil)
                return
        }
        guard let dayliCalorie = self.txtDailyCalories where (self.txtDailyCalories.text?.characters.count > 0)
            else {
                let alertController = UIAlertController.basicMessage(self.titleWarinig, message: self.messageEmail)
                self.presentViewController(alertController, animated: true, completion: nil)
                return
        }
        
        let user = ["username":username.text as! AnyObject,
            "password":password.text as! AnyObject,
            "email":email.text as! AnyObject,
            "dailyCalorie": Int(dayliCalorie.text!) as! AnyObject]
        
        let parseAPI = ParseAPI()
        parseAPI.signUp(user, success: { (data) -> Void in
                let user = User.jsonToUser(data as! [String:AnyObject])
                
                // Synchronize token on keychain
                let keychainService = KeychainService()
                keychainService.setToken(user.sessionToken!)
            
                parseAPI.basicRoleToUser( user.objectID! , success: { (data) -> Void in
                    
                    }, failure: { (error) -> Void in
                        
                })
            
                // go to main screen
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
                let calorieVC = navigationController.viewControllers.first as! CalorieVC
                calorieVC.user = user
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

                UIView.transitionWithView(self.view, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft,
                        animations: { () -> Void in
                            appDelegate.window?.rootViewController = navigationController
                    }, completion: nil)
            
            
            }, failure: { (error) -> Void in
                let  alertController = UIAlertController.basicMessage(self.titleWarinig, message: self.messageErrorServer)
                self.presentViewController(alertController, animated: true, completion: nil)
        })
        
    }
    
    
    // MARK: UINAVIGATION CONTROLLER
    @IBAction func back(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: UITEXTFIELDELEGATE
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Get the tag to keyboard not over the textfield
        self.selectedTextField = textField.tag
    }
    
}
