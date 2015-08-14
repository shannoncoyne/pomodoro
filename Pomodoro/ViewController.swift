//
//  ViewController.swift
//  Pomodoro
//
//  Created by Shannon Coyne on 8/1/15.
//  Copyright (c) 2015 Shannon Coyne. All rights reserved.
//

import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: FBSDKLoginButton! {
        didSet {
            loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let accessToken = FBSDKAccessToken.currentAccessToken() {
            // user is logged in
            println("User's ID is \(accessToken.userID)")
            println("permissions: \(accessToken.permissions)")
            getFBUserData()
        } else {
            // user is not logged in
        }
    }
    
    func getFBUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me?fields=id,email,name,friends", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                // Process error
                println("Error: \(error)")
            } else {
                println("fetched result: \(result)")
            }
        })
    }
    
}