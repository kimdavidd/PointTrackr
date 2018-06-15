//
//  LogInController.swift
//  Point Trackr
//
//  Created by David Kim on 5/21/18.
//  Copyright © 2018 David Kim. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase


class LogInController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    var ref : DatabaseReference!
    
    @IBAction func logInButton(_ sender: Any) {
        logIn()
    }
    
    func logIn() {
        if emailField.text != "" && passwordField.text != "" {
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                if user != nil { // sign in successful
                    self.addUserToDatabase()
                    self.performSegue(withIdentifier: "logInSegue", sender: self)
                } else {
                    self.errorMessage.text = "Email/Password incorrect. \nPlease try again."
                }
            }
        } else {
            self.errorMessage.text = "Email/Password incorrect. \nPlease try again."
        }
    }
    
    func addUserToDatabase() {
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser!.uid
        
        self.ref.child("users").child(userID).child("email").setValue(emailField.text)
        
        self.ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.hasChild("points") {
                self.ref.child("users").child(userID).child("points").setValue(0)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        self.emailField.delegate = self
        self.passwordField.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailField {
            self.passwordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
