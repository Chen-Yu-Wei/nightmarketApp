//
//  TViewDetailViewController.swift
//  fuck
//
//  Created by vicky on 2020/10/2.
//  Copyright © 2020 Ariel. All rights reserved.
//

import UIKit

class TViewDetailViewController: UIViewController {
    @IBOutlet var containerViews: [UIView]!
    @IBOutlet weak var change: UISegmentedControl!
    @IBOutlet weak var numberLabel: UILabel!
    var storeID = ""
    @IBAction func changePage(_ sender: UISegmentedControl) {
        for containerView in containerViews {
           containerView.isHidden = true
        }
        containerViews[sender.selectedSegmentIndex].isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        containerViews[0].isHidden = true
        containerViews[1].isHidden = false
        numberLabel.text = storeID
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMenuDetail"{
            let destinationController = segue.destination as! MenuTableViewController
            destinationController.storeID = storeID
        }
    }
}
