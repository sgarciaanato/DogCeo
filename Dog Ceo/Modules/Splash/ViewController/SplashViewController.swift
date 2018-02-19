//
//  SplashViewController.swift
//  Dog Ceo
//
//  Created by Samuel on 06-02-18.
//  Copyright © 2018 Samuel. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

            let navigationViewController = UINavigationController(rootViewController: HomeViewController())
            navigationViewController.modalTransitionStyle = .flipHorizontal

            self.present(navigationViewController, animated : true)
        }
        
    }

}
