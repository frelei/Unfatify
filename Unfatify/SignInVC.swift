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
    let fieldMessage = "The field need to be at least 5 characters"
    
    
    // MARK: IBOUTLETS
    @IBOutlet weak var txtUsername: UITextField! {
        didSet{ txtUsername.delegate = self }
    }
    
    @IBOutlet weak var txtPassword: UITextField! {
        didSet { txtPassword.delegate = self }
    }
    
    
    // MARK: LIFE CYCLE VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
    }
    

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    // MARK: UITEXTFIELDELEGATE
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: IBACTIONS
    
    @IBAction func signin(sender: UIButton) {
        // TODO: LOADER
        guard let username = self.txtUsername where self.txtUsername.charactersInRange(5)
                             else {
                                let  alertController = UIAlertController.basicMessage(self.titleWarinig, message: self.fieldMessage)
                                self.presentViewController(alertController, animated: true, completion: nil)
                                return
                             }
        guard let password = self.txtPassword where self.txtPassword.charactersInRange(5)
                            else {
                                let  alertController = UIAlertController.basicMessage(self.titleWarinig, message: self.fieldMessage)
                                self.presentViewController(alertController, animated: true, completion: nil)
                                return
                            }
        
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
            appDelegate.window?.rootViewController = navigationController
            
            }, failure: { (error) -> Void in
                let  alertController = UIAlertController.basicMessage(self.titleWarinig, message: self.messageWarning)
                self.presentViewController(alertController, animated: true, completion: nil)
        })
        
    }
    
    
    @IBAction func forgotPassword(sender: UIButton) {
        let parseAPI = ParseAPI()
        parseAPI.resetPassword("Email", success: { (data) -> Void in
            
        }, failure: { (error) -> Void in
                
        })
    }
    
    
    
    @IBAction func signup(sender: UIButton) {
        self.performSegueWithIdentifier("goToSignUp", sender: nil)
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToMainBySignIn"{
            
        }
    }

}
