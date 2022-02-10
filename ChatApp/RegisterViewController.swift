//
//  RegisterViewController.swift
//  ChatApp
//
//  Created by Keshav Raj Kashyap on 21/01/22.
//

import UIKit
import FBSDKLoginKit
import Firebase

class RegisterViewController: UIViewController {
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var textFieldPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonLogin(_ sender: UIButton) {
        let email = textFieldEmail.text ?? ""
        let password = textFieldPassword.text ?? ""
        Auth.auth().createUser(withEmail:email , password:password ) { authResult, error in
            print(error ?? "")
            print(authResult as Any)
            if error == nil{
                let homeVc = self.storyboard?.instantiateViewController(withIdentifier: "MainHomeViewController")as! MainHomeViewController
                self.navigationController?.pushViewController(homeVc, animated: true)
                print(authResult as Any)
            }else if authResult != nil{
                print("hello")
            }
        }
    }
    
    //MARK: GOOGLE BUTTON
    @IBAction func buttonGoogle(_ sender: UIButton) {
       
    }
    
    //MARK: FACEBOOK BUTTON
    @IBAction func buttonFacebook(_ sender: UIButton) {
        getFacebookUserInfo()
    }
    
    func getFacebookUserInfo(){
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile, .email ], viewController: self) { (result) in
            switch result{
            case .cancelled:
                print("Cancel button click")
            case .success:
                let params = ["fields" : "id, name, first_name, last_name, picture.type(large), email "]
                let graphRequest = GraphRequest.init(graphPath: "/me", parameters: params)
                let Connection = GraphRequestConnection()
                Connection.add(graphRequest) { (Connection, result, error) in
                    let info = result as! [String : AnyObject]
                    print(info["name"] as! String)
                    let homeVc = self.storyboard?.instantiateViewController(withIdentifier: "MainHomeViewController")as! MainHomeViewController
                    self.navigationController?.pushViewController(homeVc, animated: true)
                }
                Connection.start()
            default:
                print("??")
            }
        }
    }

}
