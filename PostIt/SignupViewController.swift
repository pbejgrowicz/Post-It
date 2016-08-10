//
//  SignupViewController.swift
//  PostIt
//
//  Created by Speednet on 10.08.2016.
//  Copyright © 2016 Patryk Bejgrowicz. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passwordTextField.secureTextEntry = true;
        confirmPasswordTextField.secureTextEntry = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(sender: AnyObject) {
        self.performSegueWithIdentifier("showLoginViewAgain", sender: self)
    }

    @IBAction func createAccountPressed(sender: AnyObject) {
        if emailTextField.text == "" || passwordTextField.text == "" || confirmPasswordTextField.text == "" {
            //alert
            let alert = UIAlertController(title: "Something goes wrong:(", message: "You need to fill all fields", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            
            presentViewController(alert, animated: true, completion: nil)
        } else if confirmPasswordTextField.text != passwordTextField.text {
            //alert
            let alert = UIAlertController(title: "Something goes wrong:(", message: "Passwords don't match", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            
            presentViewController(alert, animated: true, completion: nil)
        } else {
            //register new account and segue to home
            FIRAuth.auth()?.createUserWithEmail(emailTextField.text!, password: passwordTextField.text!, completion: { (user:FIRUser?, error:NSError?) in
                if error != nil {
                    print(error?.description.componentsSeparatedByString("\"")[1])
                    let alert = UIAlertController(title: "Something goes wrong:(", message: error?.description.componentsSeparatedByString("\"")[1], preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(defaultAction)
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    self.performSegueWithIdentifier("showHomeAfterRegister", sender: self)
                }
            })
            
            

        }
        
        
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
