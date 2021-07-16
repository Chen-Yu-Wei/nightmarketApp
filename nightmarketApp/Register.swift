//
//  Register.swift
//  fuck
//
//  Created by Ariel on 2020/6/1.
//  Copyright © 2020 Ariel. All rights reserved.
//

import UIKit

class Register: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypepassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAction(_ sender: Any) {
        let u = validatePassword(passwd: passwordTextField.text!)
        if emailTextField.text == "" || passwordTextField.text != retypepassword.text || u != "OK" {
                    //彈出警告
        let alertController = UIAlertController(title: "Error", message: "your email is empty or Security issue", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
                    
        } else {
            //需要增加"建立帳號"
            
            
            if true  { //需要增加"建立成功的條件"
                let alertController = UIAlertController(title: "Success", message:"You have successfully signed up", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) in
                    //成功後回前頁
                    self.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                //建立失敗，跳出警告
                let alertController = UIAlertController(title: "Error", message: "Create Error", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
                        
        }
    }
    
    func validatePassword(passwd:String)-> String{
        var r = "No"
        var isLongEnough:Bool = false
        var hasUppercase = false
        var hasLowercase = false
        var hasNumber = false
        if passwd.count >= 8 {
            isLongEnough = true
        }
        for char:Character in passwd {
            let str:String = "\(char)"
            let num:Int? = Int(str)
            if (str.uppercased() == str) && (Int(str) == nil) {
                hasUppercase = true
            }
            if (str.lowercased() == str) && (Int(str) == nil)  {
                hasLowercase = true
            }
            if num == num{
                hasNumber = true
            }else{
                hasNumber = false
            }
        }
        if isLongEnough && hasNumber && hasUppercase && hasLowercase {
            r = "OK"
        }
        return r
    }
    
   
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
