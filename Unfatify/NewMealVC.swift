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


class NewMealVC: UIViewController {

    // MARK: MESSAGE
    let titleAlert = "Unfatify"
    let messageField = "The field cannot be empty"
    let messagelUpdate = "Meal update success"
    let messageFailure = "Meal not update."
    
    
    // MARK: ATTRIBUTE
    var user: User?
    var delegate: NewMealDelegate?
    
    // MARK: IBOUTLETS
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCalorie: UITextField!
    
    // MARK: VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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

}
