//
//  PersonalAccount.swift
//  fuck
//
//  Created by Ariel on 2020/6/1.
//  Copyright © 2020 Ariel. All rights reserved.
//

import UIKit

class PersonalAccount: UIViewController {



    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func login(_ sender: Any) {
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            //彈出警告
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            if true {
                //需要增加"判斷登入是否成功"
                
                //登入成功，進入下頁
                let userDefaults = UserDefaults.standard
                _ = userDefaults.value(forKey: "isLogined") as? Bool
                userDefaults.set(true, forKey: "isLogined")
                _ = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
                // dismiss把畫面砍掉 表示再出現的時候會在viewdidload一次
                self.dismiss(animated: true, completion: nil)
            } else {
                //登入失敗，彈出警告
                let userDefaults = UserDefaults.standard
                _ = userDefaults.value(forKey: "isLogined") as? Bool
                userDefaults.set(false, forKey: "isLogined")
                let alertController = UIAlertController(title: "Error", message: "wrong email or wrong password", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                //叫出新的畫面
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
 

    
    @IBAction func dismissNext(segue:UIStoryboardSegue){
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
