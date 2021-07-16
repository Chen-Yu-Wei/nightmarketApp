//  fuck
//
//  Created by Ariel on 2020/6/1.
//  Copyright © 2020 Ariel. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    
  

    @IBAction func logout(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        _ = userDefaults.value(forKey: "isLogined") as? Bool
        userDefaults.set(true, forKey: "isLogined")
        _ = self.storyboard?.instantiateViewController(withIdentifier: "PersonalAccount")
        // dismiss把畫面砍掉 表示再出現的時候會在viewdidload一次
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
   /* override func viewDidAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        let isLogined = userDefaults.value(forKey: "isLogined") as? Bool
        //if isLogined != nil && isLogined! {
            
        //}
        //else{
            let logVC = self.storyboard?.instantiateViewController(withIdentifier: "PersonalAccount")
            present(logVC!, animated: true, completion: nil)
        //}
    }*/

}

