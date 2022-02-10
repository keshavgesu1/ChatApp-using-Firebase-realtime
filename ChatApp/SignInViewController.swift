//
//  ViewController.swift
//  ChatApp
//
//  Created by Keshav Raj Kashyap on 21/01/22.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController {
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var textfieldEmail: UITextField!
    var userDict = [String:AnyObject]()
    
    //MARK: VIEW CONTROLLER LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ///is user login
        checkUserLogin()
    }
    
    //MARK: LOGIN BUTTON
    //using firebase button for sign in 
    @IBAction func buttonLogin(_ sender: UIButton) {
//        let numbers = [0]
//            let _ = numbers[1]
        let email = textfieldEmail.text ?? ""
        let password = textfieldPassword.text ?? ""
        Auth.auth().signIn(withEmail: email, password: password){ [weak self ] user, error in
            if error == nil{
                let homeVc = self?.storyboard?.instantiateViewController(withIdentifier: "MainHomeViewController")as! MainHomeViewController
                self?.navigationController?.pushViewController(homeVc, animated: true)
            }else if user != nil{
                print("hello")
            }else{
                print("something is wrong")
            }
        }
    }
    
    //MARK: GOOGLE BUTTON
   
    @IBAction func buttonGoogle(_ sender: Any) {
       // GIDSignIn.sharedInstance.signIn(with: GIDConfiguration., presenting: self)
        
    }
    @IBAction func buttonSignUp(_ sender: UIButton) {
        let nextVc = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController")as! RegisterViewController
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    //MARK: FACEBOOK BUTTON
  
    @IBAction func buttonFaceBook(_ sender: Any) {
        getFacebookUserInfo()
    }
    
    ///get facebook user info
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
                    self.userDict = info
                    UserDefaults.standard.set(self.userDict, forKey: "userData")
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
    func checkUserLogin(){
        if let token = AccessToken.current,
            !token.isExpired {
            // User is logged in, do work such as go to next view controller.
            let homeVc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")as! HomeViewController
            navigationController?.pushViewController(homeVc, animated: true)
        }
    }
        //dismiss textField on tap of return
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                view.endEditing(true)
                return false
            }
    //MARK:Google SignIn Delegate
     func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
      // myActivityIndicator.stopAnimating()
        }

    // Present a view that prompts the user to sign in with Google
       func sign(_ signIn: GIDSignIn!,
                  present viewController: UIViewController!) {
            self.present(viewController, animated: true, completion: nil)
        }

    // Dismiss the "Sign in with Google" view
     func sign(_ signIn: GIDSignIn!,
                  dismiss viewController: UIViewController!) {
            self.dismiss(animated: true, completion: nil)
        }

    //completed sign In
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

            if (error == nil) {
          // Perform any operations on signed in user here.
             /*   let userId = user.userID                  // For client-side use only!
               let idToken = user.authentication.idToken // Safe to send to the server
                let fullName = user.profile?.name
               let givenName = user.profile?.givenName
               let familyName = user.profile?.familyName
               let email = user.profile?.email
              */
                     } else {
                         print("\(error.localizedDescription)")
                     }
                 }
    }




