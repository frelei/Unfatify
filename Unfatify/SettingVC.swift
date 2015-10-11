//
//  SettingVC.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 09/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    // MARK: ATTRIBUTES
    var user: User?
    
    
    // MARK: IBOUTLET
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblImage: UIImageView!
    @IBOutlet weak var lblGoal: UILabel!
    
    
    // MARK: LIFE CYCLE VC
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        self.lblGoal.text = "\(user!.dailyCalorie!)"
        self.lblName.text = "@\(user!.username!)"
    }
    
    // MARK: IBACTIONS
    @IBAction func touchChangeGoal(sender: UIButton) {
        self.performSegueWithIdentifier("goToChangeGoal", sender: user)
    }
    
    
    @IBAction func touchLogout(sender: UIButton) {
        let keychainService = KeychainService()
        let token = keychainService.getToken()
        
        // Get login Storyboard
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let parseAPI = ParseAPI()
        parseAPI.logout(token!, success: { (data) -> Void in
            
            }, failure: { (error) -> Void in
                
            })
        
        keychainService.deleteToken()
        UIView.transitionWithView(self.view, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight,
            animations: { () -> Void in
                appDelegate.window?.rootViewController = navigationController
            }, completion: nil)
    }
    
    
    @IBAction func touchTakePicture(sender: UIButton) {
        
    }
    
    
    @IBAction func touchFilter(sender: UIButton) {
        self.performSegueWithIdentifier("goToFilter", sender: user)
    }
    
    
    @IBAction func touchClose(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToChangeGoal"{
            let goalVC = segue.destinationViewController as! GoalVC
            goalVC.user = sender as? User
        }else if segue.identifier == "goToFilter"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let filterVC = navigationController.viewControllers.first as! FilterVC
//            filterVC.delegate = self
            filterVC.user = sender as? User
        }
    }
    

}
