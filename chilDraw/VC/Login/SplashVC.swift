//
//  SplashVC.swift
//  chilDraw
//
//  Created by 갓거 on 2017. 12. 9..
//  Copyright © 2017년 갓거. All rights reserved.
//

import Foundation
import UIKit

class SplashVC : UIViewController {
    var delayInSeconds = 2.0
    
    override func viewDidLoad() {
        autoLoginAndSplash()
    }
    
    func autoLoginAndSplash() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds){
            guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") else {return}
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
    
}
