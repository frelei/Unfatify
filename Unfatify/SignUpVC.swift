//
//  SignUpVC.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 07/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController, UITextFieldDelegate {

    
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
        
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: IBACTIONS
    
    
    @IBAction func signUp(sender: UIButton) {
        
        
        
    }
    
    
    
    @IBAction func back(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
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
