//
//  HomeTableViewController.swift
//  PostIt
//
//  Created by Speednet on 09.08.2016.
//  Copyright © 2016 Patryk Bejgrowicz. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class HomeTableViewController: UITableViewController {
    
    
    
    var dbRef:FIRDatabaseReference!
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference().child("post-items")
        startObservingDB()

    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth:FIRAuth, user:FIRUser?) in
            if let user = user {
                print("Welcome \(user.email)")
                self.startObservingDB()
            }else {
                print("you need ot sign up or login first")
            }
        })
    }
    
    
    @IBAction func addPost(sender: AnyObject) {
        let postAlert = UIAlertController(title: "New Post", message: "Enter your post", preferredStyle: .Alert)
        postAlert.addTextFieldWithConfigurationHandler { (textField:UITextField) in
            textField.placeholder = "Your post"
        }
       
        
        postAlert.addAction(UIAlertAction(title: "Send", style: .Default, handler: { (action:UIAlertAction) in
            if let postContent = postAlert.textFields?.first?.text {
                let post = Post(content: postContent, addedByUser: "BriaAdvent")
                
                let postRef = self.dbRef.child(postContent.lowercaseString)
                
                postRef.setValue(post.toAnyObject())
            }
        }))
        
        
        self.presentViewController(postAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func loginAndSignUp(sender: AnyObject) {
        
        let userAlert = UIAlertController(title: "Login/Sign up", message: "enter email and password", preferredStyle: .Alert)
        
        userAlert.addTextFieldWithConfigurationHandler{ (textfield:UITextField) in
            textfield.placeholder = "email"
        }
        
        userAlert.addTextFieldWithConfigurationHandler{ (textfield:UITextField) in
            textfield.secureTextEntry = true
            textfield.placeholder = "password"
        }
        
        userAlert.addAction(UIAlertAction(title: "Sign in", style: .Default, handler: { (action:UIAlertAction) in
            let emailTextField = userAlert.textFields!.first!
            let passwordTextField = userAlert.textFields!.last!
            
            FIRAuth.auth()?.signInWithEmail(emailTextField.text!, password: passwordTextField.text!, completion: { (user:FIRUser?, error:NSError?) in
                if error != nil {
                    print(error?.description)
                }
            })
        }))
        
        userAlert.addAction(UIAlertAction(title: "Sign up", style: .Default, handler: { (action:UIAlertAction) in
            let emailTextField = userAlert.textFields!.first!
            let passwordTextField = userAlert.textFields!.last!
            
            FIRAuth.auth()?.createUserWithEmail(emailTextField.text!, password: passwordTextField.text!, completion: { (user:FIRUser?, error:NSError?) in
                if error != nil {
                    print(error?.description)
                }
            })
        }))
        
        self.presentViewController(userAlert, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    

    func startObservingDB () {
        dbRef.observeEventType(.Value, withBlock: {
            (snapshot:FIRDataSnapshot) in
                var newPosts = [Post]()
            
            for post in snapshot.children {
                let postObject = Post(snapshot: post as! FIRDataSnapshot)
                newPosts.append(postObject)
            }
            
            self.posts = newPosts
            self.tableView.reloadData()
            
        }) { (error:NSError) in
            print(error.description)
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let post = posts[indexPath.row]
        
        cell.textLabel?.text = post.content
        cell.detailTextLabel?.text = post.addedByUser

        return cell
    }

    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let post = posts[indexPath.row]
            
            post.itemRef?.removeValue()
        }
    }


}
