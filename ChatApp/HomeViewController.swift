//
//  HomeViewController.swift
//  ChatApp
//
//  Created by Keshav Raj Kashyap on 21/01/22.
//

import UIKit
import FBSDKLoginKit

class HomeViewController: UIViewController {
    @IBOutlet weak var labelWelcomeName:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
       setUserData()
    }
    
    func setUserData(){
        let user = UserDefaults.standard.value(forKey: "userData")
        print(user as! [String:AnyObject])
       // self.labelWelcomeName = user
    }
    @IBAction func backButton(_ sender: Any) {
    }
    
    @IBAction func buttonLogout(_ sender: Any) {
      //  var token = AccessToken.current
        //token.
        let loginManager = LoginManager()
        loginManager.logOut()
        self.navigationController?.popViewController(animated: true )
    }
    

}
