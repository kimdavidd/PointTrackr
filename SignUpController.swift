//
//  SignUpController.swift
//  Point Trackr
//
//  Created by David Kim on 5/20/18.
//  Copyright © 2018 David Kim. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SignUpController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    
    @IBAction func continueButton(_ sender: Any) {
        signUp()
    }
    
    func signUp() {
        guard let email = emailField.text else { return }
        guard let pass = passwordField.text else { return }
        guard let confirmPass = confirmPasswordField.text else { return }
        
        if nameField.text == "" {
            self.errorMessage.text = "Please enter your name!"
        } else if pass == confirmPass {
            Auth.auth().createUser(withEmail: email, password: pass) { user, error in
                if error != nil {
                    self.errorMessage.text = "Email invalid or already exists!"
                } else {
                    Auth.auth().signIn(withEmail: self.emailField.text!, password: self.passwordField.text!) { (user, error) in }
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.nameField.text
                    changeRequest?.commitChanges { (error) in
                        if error != nil {
                            print(error!)
                        }
                    }
                    do {
                        try Auth.auth().signOut()
                    }
                    catch let error as NSError {
                        print(error.localizedDescription)
                    }
                    self.performSegue(withIdentifier: "signUpSegue", sender: self)
                }
            }
        } else {
            self.errorMessage.text = "Passwords do not match!"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() // needed
        self.nameField.delegate = self
        self.emailField.delegate = self
        self.passwordField.delegate = self
        self.confirmPasswordField.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameField {
            self.emailField.becomeFirstResponder()
        } else if textField == self.emailField {
            self.passwordField.becomeFirstResponder()
        } else if textField == self.passwordField {
        self.confirmPasswordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
