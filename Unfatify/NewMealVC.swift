//
//  NewMealVC.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 10/12/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

protocol NewMealDelegate{
    func newMealDidFinish(newMeal: NewMealVC, result: Bool)
}


class NewMealVC: UIViewController, UITextFieldDelegate {

    // MARK: MESSAGE
    let titleAlert = "Unfatify"
    let messageField = "The field cannot be empty"
    let messagelUpdate = "Meal update success"
    let messageFailure = "Meal not update."
    
    // MARK: ATTRIBUTE
    var user: User?
    var delegate: NewMealDelegate?
    var selectedTextField = 0
    let gap = 3.0
    
    // MARK: IBOUTLETS
    @IBOutlet weak var txtName: UITextField!{
        didSet{ self.txtName.delegate = self }
    }
    @IBOutlet weak var txtCalorie: UITextField!{
        didSet{ self.txtCalorie.delegate = self }
    }
    
    // MARK: VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: TOUCH
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.txtCalorie.resignFirstResponder()
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
    @IBAction func touchBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func touchSubmit(sender: UIButton) {
        guard let name = self.txtName where self.txtName.charactersInRange(1)
            else {
                let  alertController = UIAlertController.basicMessage(self.titleAlert, message: self.messageField)
                self.presentViewController(alertController, animated: true, completion: nil)
                return
        }
        
        guard let calorie = self.txtCalorie where self.txtCalorie.charactersInRange(1)
            else {
                let  alertController = UIAlertController.basicMessage(self.titleAlert, message: self.messageField)
                self.presentViewController(alertController, animated: true, completion: nil)
                return
        }
        
        let keychainService = KeychainService()
        let token = keychainService.getToken()
        
        let parseAPI = ParseAPI()
        let data = ["name": name.text as! AnyObject,
                    "calorie": Int(calorie.text!) as! AnyObject,
                    "user": UserMeal.createUserPointer((user?.objectID)!) ]
        parseAPI.createObject("Meal", token: token!, data: data, success: { (data) -> Void in
                self.delegate?.newMealDidFinish(self, result: true)
            }) { (error) -> Void in
                self.delegate?.newMealDidFinish(self, result: false)
        }
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
