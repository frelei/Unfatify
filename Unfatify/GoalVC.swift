//
//  GoalVC.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 10/11/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

protocol GoalDelegate{
    func goalDidFinish(goalVC:GoalVC, result:Bool)
}

class GoalVC: UIViewController, UITextFieldDelegate {

    // MARK: MESSAGES
    let messageTitle = "Unfatify"
    let messageField = "The field cannot be empty"
    let messageGoalUpdate = "Goal update Success"
    let messageGoalFailure = "Goal not update."
    
    // MARK: ATTRIBUTES
    var user:User?
    var delegate:GoalDelegate?
    var selectedTextField = 0
    let gap = 4.0
    
    // MARK: IBOUTLET
    @IBOutlet weak var txtNewGoal: UITextField!{
        didSet{ self.txtNewGoal.delegate = self }
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
        self.txtNewGoal.resignFirstResponder()
    }
    
    // MARK: KEYBOARD
    func keyboardWillShow(notification: NSNotification){
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size.height
        let size =   Double(keyboardSize!)  *  Double( Double(self.selectedTextField) / self.gap)
        self.view.frame.origin.y = 0
        self.view.frame.origin.y -=  CGFloat(size)
    }
    
    func keyboardWillHide(notification: NSNotification){
        self.view.frame.origin.y = 0
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
                self.delegate!.goalDidFinish(self, result: true)
            }, failure:{ (error) -> Void in
                self.delegate!.goalDidFinish(self,result:  false)
        })
        
    }
    
    @IBAction func touchBack(sender: UIButton) {
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
