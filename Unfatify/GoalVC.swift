//
//  GoalVC.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 10/11/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

class GoalVC: UIViewController {

    // MARK: MESSAGES
    let messageTitle = "Unfatify"
    let messageField = "The field cannot be empty"
    
    
    // MARK: ATTRIBUTES
    var user:User?
    
    // MARK: IBOUTLET
    
    @IBOutlet weak var txtNewGoal: UITextField!
    
    
    // MARK: LIFE CYCLE VC
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: IBACTIONS
    
    @IBAction func touchChangeGoal(sender: UIButton) {
        guard let goal = self.txtNewGoal where self.txtNewGoal.charactersInRange(1)
            else {
                let  alertController = UIAlertController.basicMessage(self.messageTitle, message: self.messageField)
                self.presentViewController(alertController, animated: true, completion: nil)
                return
        }
        let keychainService = KeychainService()
        let token = keychainService.getToken()
        
        // TODO: LOADER
        
        user?.dailyCalorie = NSNumber( integer: Int( goal.text! )! )
        let userDataToUpdate = ["dailyCalorie": user?.dailyCalorie as! AnyObject]
        let parseAPI = ParseAPI()
        parseAPI.updateUser(userDataToUpdate, userID: (user?.objectID)!, token: token!, success: { (data) -> Void in
                 self.navigationController?.popViewControllerAnimated(true)
            }, failure:{ (error) -> Void in
                 self.navigationController?.popViewControllerAnimated(true)
        })
        
    }
    
    @IBAction func touchBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }


}