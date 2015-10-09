//
//  SignInVC.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 07/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

class SignInVC: UIViewController, UITextFieldDelegate {

    
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
    
    
    
    // MARK: INITIALIZERS
    
    func checkSessionUser(){
        
        // Allocate the keychain
//        let keychainService = KeychainService()
//        let token = keychainService.getToken()
//        
        
        // TODO: Loader until check if user has a token
//        if let tokenValue = token{
//            
//            // Check if user has a session
//            let parseApi = ParseAPI()
//            parseApi.currentUser(tokenValue, success: { (data) -> Void in
//                // Go to Main
//                
//                }, failure: { (error) -> Void in
//                    // Error to get user stay on the singinvc
//            })
//        }
        
    }
    
    
    // MARK: UITEXTFIELDELEGATE
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: IBACTIONS
    
    @IBAction func signin(sender: UIButton) {
        let parseAPI = ParseAPI()
        parseAPI.signIn(self.txtUsername.text!, password: self.txtPassword.text!, success: { (data) -> Void in
            
            }, failure: { (error) -> Void in
                
        })
        
    }
    
    
    @IBAction func forgotPassword(sender: UIButton) {
        let parseAPI = ParseAPI()
        parseAPI.resetPassword("Email", success: { (data) -> Void in
            
        }, failure: { (error) -> Void in
                
        })
    }
    
    
    
    @IBAction func signup(sender: UIButton) {
        self.performSegueWithIdentifier("goToSignUpVC", sender: nil)
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
