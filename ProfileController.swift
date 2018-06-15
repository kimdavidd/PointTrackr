//
//  ProfileController.swift
//  Point Trackr
//
//  Created by David Kim on 5/21/18.
//  Copyright © 2018 David Kim. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class ProfileController: UIViewController {
    
    var ref : DatabaseReference!
    
    @IBOutlet weak var helloMessage: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBAction func logOutButton(_ sender: Any) {
        logOut()
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        self.performSegue(withIdentifier: "logOutSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        updateName()
        updatePoints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateName() {
        self.helloMessage.text = "Hello " + (Auth.auth().currentUser?.displayName)!
    }
    
    func updatePoints() {
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).child("points").observeSingleEvent(of: .value) {
            (snapshot) in
            if let points = snapshot.value as? Int {
                self.pointsLabel.text = "\(points)"
            }
        }
    }
    
}
