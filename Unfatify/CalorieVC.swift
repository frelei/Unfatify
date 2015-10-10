//
//  CalorieVC.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 07/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

class CalorieVC: UIViewController {

    //MARK: Attributes
    var user: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let keychainService = KeychainService()
        let token = keychainService.getToken()
        user = User.currentUser(token!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true

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
