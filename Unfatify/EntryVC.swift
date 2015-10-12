//
//  EntryVC.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 10/11/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

protocol EntryDelegate{
    func entryDidFinish(entryVC:EntryVC,result:Bool)
}

/// Class handle new Entry on meals of the user
class EntryVC: UIViewController, UITextFieldDelegate {

    //MARK: MESSAGES
    let titleAlert = "Enfatify"
    let messageField = "Field need to have at least 1 character"
    
    // MARK: VARIABLES
    var delegate: EntryDelegate?
    var user: User?
    var selectedTextField = 0
    let gap = 4.0
    
    // MARK: IBOUTLET
    @IBOutlet weak var txtFoodName: UITextField!{
        didSet{ txtFoodName.delegate = self }
    }
    @IBOutlet weak var txtCalorie: UITextField!{
        didSet{ txtCalorie.delegate = self }
    }
    
    // MARK: VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
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
        self.txtCalorie.resignFirstResponder()
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
    
    
    // MARK: IBACTION
    @IBAction func touchClose(sender: UIButton) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func touchSend(sender: UIButton) {
        
        guard let name = self.txtFoodName where self.txtFoodName.charactersInRange(1)
            else {
                let  alertController = UIAlertController.basicMessage(self.titleAlert, message: self.messageField)
                self.presentViewController(alertController, animated: true, completion: nil)
                return
        }
        
        guard let calorie = self.txtCalorie where self.txtFoodName.charactersInRange(1)
            else {
                let  alertController = UIAlertController.basicMessage(self.titleAlert, message: self.messageField)
                self.presentViewController(alertController, animated: true, completion: nil)
                return
        }
        
        let meal = ["name":name.text as! AnyObject,
                    "calorie": Int(calorie.text!) as! AnyObject,
                    "user": ["__type":"Pointer","className":"_User","objectId":(user?.objectID)!]]        

        let keychainService = KeychainService()
        let token = keychainService.getToken()
        
        let parseAPI = ParseAPI()
        parseAPI.createObject("UserMeal", token: token!, data: meal, success: { (data) -> Void in
                self.delegate!.entryDidFinish(self, result: true)
              }, failure: { (error) -> Void in
                self.delegate!.entryDidFinish(self, result: false)
              })
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
