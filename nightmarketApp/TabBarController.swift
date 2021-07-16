//
//  TabBarController.swift
//  fuck
//
//  Created by Rick on 2020/9/28.
//  Copyright © 2020 Ariel. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
           let userDefaults = UserDefaults.standard
           let isLogined = userDefaults.value(forKey: "isLogined") as? Bool
           //if isLogined != nil && isLogined! {
               
           //}
           //else{
               let logVC = self.storyboard?.instantiateViewController(withIdentifier: "PersonalAccount")
               present(logVC!, animated: true, completion: nil)
           //}
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
