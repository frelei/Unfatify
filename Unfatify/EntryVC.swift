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
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: TOUCH
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.txtCalorie.resignFirstResponder()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
