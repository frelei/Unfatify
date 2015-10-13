//
//  SettingVC.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 09/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit
import QuartzCore

class SettingVC: UIViewController, GoalDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: MESSAGES
    let messageTitle = "Unfatify"
    let messageCam = "Camera Not Found"
    let messageCamDevice = "This device has no Camera"
    let messageUpload = "Photo Uploaded Success"
    
    // MARK: ATTRIBUTES
    var user: User?
    var imagePicker: UIImagePickerController? = UIImagePickerController()
    
    // MARK: IBOUTLET
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblImage: UIImageView!
    @IBOutlet weak var lblGoal: UILabel!
    @IBOutlet weak var manager: UIButton!
    @IBOutlet weak var photo: UIImageView!
    
    // MARK: LIFE CYCLE VC
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        self.manager.hidden = true
        self.imagePicker?.delegate = self
        
        // Load user image
        self.photo.loadImageAsyncFromUrl(user?.picture)

        let parseAPI = ParseAPI()
        parseAPI.rolesUser( (user?.objectID)! , success: { (data) -> Void in
                let roles = data as! [[String:AnyObject]]
                let result = roles.filter({  $0["name"] as! String == "Manager" })
                if result.count != 0 {
                    self.manager.hidden = false
                }
            }, failure: { (error) -> Void in
                
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.lblGoal.text = "\(user!.dailyCalorie!)"
        self.lblName.text = "@\(user!.username!)"
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    // MARK: IBACTIONS
    @IBAction func touchChangeGoal(sender: UIButton) {
        self.performSegueWithIdentifier("goToChangeGoal", sender: user)
    }
    
    
    @IBAction func touchLogout(sender: UIButton) {
        let keychainService = KeychainService()
        let token = keychainService.getToken()
        
        // Get signIn Storyboard
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let signIn = navigationController.viewControllers.first as! SignInVC
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let parseAPI = ParseAPI()
        parseAPI.logout(token!, success: { (data) -> Void in
            
            }, failure: { (error) -> Void in
                
            })
        keychainService.deleteToken()
        UIView.transitionWithView(self.view, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromRight,
            animations: { () -> Void in
                appDelegate.window?.rootViewController = navigationController
            }, completion: nil)
        
        UIView.transitionFromView(self.view, toView: signIn.view, duration: 0.5, options: .TransitionFlipFromLeft,
                completion: { (result) -> Void in
                    appDelegate.window?.rootViewController = navigationController
        })
        
    }
    
    
    @IBAction func touchTakePicture(sender: UIButton) {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            imagePicker!.allowsEditing = false
            imagePicker!.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker!.cameraCaptureMode = .Photo
            self.presentViewController(imagePicker!, animated: true, completion: nil)
        }else{
            let  alertController = UIAlertController.basicMessage(self.messageTitle, message: self.messageCamDevice)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func touchFilter(sender: UIButton) {
        self.performSegueWithIdentifier("goToFilter", sender: user)
    }
    
    
    @IBAction func touchClose(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func touchManager(sender: UIButton) {
        self.performSegueWithIdentifier("goToManager", sender: user)
    }
    
    // MARK: GoalDelegate
    func goalDidFinish(goalVC:GoalVC, result:Bool){
        self.navigationController?.popViewControllerAnimated(true)
        if result{
            let  alertController = UIAlertController.basicMessage(goalVC.messageTitle, message: goalVC.messageGoalUpdate)
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            let  alertController = UIAlertController.basicMessage(goalVC.messageTitle, message: goalVC.messageGoalFailure)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: PICKER IMAGE DELEGATE
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.photo.contentMode  = .ScaleAspectFill
        self.photo.image = chosenImage
        picker.dismissViewControllerAnimated(true, completion: nil)
        let dataImage = UIImageJPEGRepresentation(chosenImage, 0.5)

        let parseAPI = ParseAPI()
        parseAPI.uploadFile((user?.objectID)!, data: dataImage!, success: { (data) -> Void in
            if let  dataValue = data{
                if let url = dataValue["url"]{
                    parseAPI.updateUser(["picture":url!], userID: (self.user?.objectID)!, token: (self.user?.sessionToken)!, success: { (data) -> Void in
                            let  alertController = UIAlertController.basicMessage(self.messageTitle, message: self.messageUpload)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }, failure: { (error) -> Void in
                    
                    })
                }
            }
            }, failure: { (error) -> Void in
                
        })
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToChangeGoal"{
            let goalVC = segue.destinationViewController as! GoalVC
            goalVC.delegate = self
            goalVC.user = sender as? User
        }else if segue.identifier == "goToFilter"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let filterVC = navigationController.viewControllers.first as! FilterVC
            filterVC.user = sender as? User
        }else if segue.identifier == "goToManager"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let managerVC = navigationController.viewControllers.first as! ManagerVC
            managerVC.user = sender as? User
        }
    }
    

}
