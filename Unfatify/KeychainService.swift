//
//  KeychainService.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 08/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit
import Locksmith

/// KeychainService is a class to store and retrieve values from keychain
class KeychainService {

    // MARK: CONSTANTS
    let kToken = "TOKEN"

    
    //MARK: METHODS
    
    /**
    Put the user token on the keychain,
        if the token doesnt exist, insert on the keychain.
        otherwise update the token value on the keychian.
    
        - @Parameter token: the value of the token
    */
    func setToken(token: String){
        do{
            try Locksmith.saveData([kToken:token], forUserAccount: kToken)
        } catch LocksmithError.Duplicate{
            do {
                try Locksmith.updateData([kToken:token], forUserAccount: kToken)
            } catch _ {
                print("Error update keychain data" )
            }
        }catch _ {
            print("Error Save keychain data")
        }
    }
    
    /**
    Retrieve the token value of the keychain
    
        - @Parameter token: the value of the token
        - @return : The token value
    */
    func getToken() -> String?{
        let tokenValue = Locksmith.loadDataForUserAccount(kToken)
        if let unwrap = tokenValue{
            return unwrap[kToken] as? String
        }else{
            return nil
        }
    }
    
    /**
    Delete the token value of the keychain
    
    */
    func deleteToken(){
        do{
            try Locksmith.deleteDataForUserAccount(kToken)
        } catch LocksmithError.NotFound  {
            
        } catch _ {
            print("Error delete keychain data")
        }
    }
    
    
}
