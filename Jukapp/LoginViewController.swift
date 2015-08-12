//
//  LoginViewController.swift
//  Jukapp
//
//  Created by Berk Caputcu on 2015-08-10.
//  Copyright (c) 2015 Berk Caputcu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let api = JukappAPI()
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInFailed: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signInTapped(sender: AnyObject) {
        api.signIn(usernameTextField.text, password: passwordTextField.text, completion: { (loginSuccess: Bool) in
            if loginSuccess {
                self.signInFailed.hidden = true

                var loginSuccessController : UINavigationController
                if (Router.CurrentRoomId > 0) {
                    loginSuccessController = self.storyboard!.instantiateViewControllerWithIdentifier("FavoritesNavigationController") as! UINavigationController
                } else {
                    loginSuccessController = self.storyboard!.instantiateViewControllerWithIdentifier("RoomsNavigationController") as! UINavigationController
                }
                
                self.revealViewController().pushFrontViewController(loginSuccessController, animated: true)
            } else {
                self.signInFailed.hidden = false
            }
        })
    }

    @IBAction func backButtonTapped(sender : AnyObject) {
        let backNavigationController = self.storyboard!.instantiateViewControllerWithIdentifier("RoomsNavigationController") as! UINavigationController
        self.revealViewController().pushFrontViewController(backNavigationController, animated: true)
    }
    
}
