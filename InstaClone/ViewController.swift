//
//  ViewController.swift
//  InstaClone
//
//  Created by Taha Cakir on 21.03.2021.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
//        alttaki işlem bir giriş yapıldıktan sonra tekrar hatırlama opsiyonu içindir.SceneDelegate ta yapılacak.
//        let currentUser = Auth.auth().currentUser
//        if currentUser != nil {
//            self.performSegue(withIdentifier: "toFeedVC", sender: nil)
//        }
        // Do any additional setup after loading the view.
    }

    @IBAction func signUpClicked(_ sender: Any) {
//        kullanıcı oluşturmak için baslıyoruz
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                if error != nil {
//                    hata mesajını firebase den aldık error.localized diyerek
                    self.makeAlert(titleInp: "Error", messageInp: error?.localizedDescription ?? "Error")
                    
                } else {
//                    eğer eksik yoksa giriş yap diyoruz.
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }

            
            
        }else{
//            hata olursa
            makeAlert(titleInp: "Error", messageInp: "Incorrect")
            
            
        }
        
    }
    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                if error != nil {
                    self.makeAlert(titleInp: "Error", messageInp: error?.localizedDescription ?? "Error")
                }else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
    }
    
    func makeAlert(titleInp : String,messageInp : String) {
        let alert = UIAlertController(title: titleInp , message: messageInp, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

