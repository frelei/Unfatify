//
//  EditVC.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 10/11/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

protocol EditDelegate{
    func EditDidFinish(editVC: EditVC, result: Bool)
}


class EditVC: UIViewController {

    // MARK: MESSAGE
    let titleAlert = "Unfatify"
    let messageField = "The field cannot be empty"
    let messageGoalUpdate = "Meal update Success"
    let messageGoalFailure = "Meal not update."
    
    // MARK: ATTRIBUTES
    var user: User?
    var userMeal: UserMeal?
    var delegate: EditDelegate?
    
    // MARK: IBOUTLET

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCalorie: UITextField!
    
    // MARK: VC LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtCalorie.text = String( Int((userMeal?.calorie)!) )
        self.txtName.text =  userMeal?.name
    }

    
    // MARK: IBACTIONS
    
    @IBAction func touchEdit(sender: UIButton) {
        
        guard let name = self.txtName where self.txtName.charactersInRange(1)
            else {
                let  alertController = UIAlertController.basicMessage(self.titleAlert, message: self.messageField)
                self.presentViewController(alertController, animated: true, completion: nil)
                return
        }
        
        guard let calorie = self.txtCalorie where self.txtName.charactersInRange(1)
            else {
                let  alertController = UIAlertController.basicMessage(self.titleAlert, message: self.messageField)
                self.presentViewController(alertController, animated: true, completion: nil)
                return
        }
        
        let data = ["name":name.text as! AnyObject,
                    "calorie": Int(calorie.text!) as! AnyObject]
        let parseAPI = ParseAPI()
        parseAPI.updateObject("UserMeal", objectId: (userMeal?.objectId)!, data: data, success: { (data) -> Void in
                self.delegate!.EditDidFinish(self, result:true)
            }, failure: { (error) -> Void in
                self.delegate!.EditDidFinish(self, result: false)
        })
    }
    
    
    @IBAction func touchClose(sender: UIButton) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

}
