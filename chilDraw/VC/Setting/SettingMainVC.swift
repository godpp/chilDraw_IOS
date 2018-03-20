//
//  SettingMainVC.swift
//  chilDraw
//
//  Created by 갓거 on 2017. 12. 11..
//  Copyright © 2017년 갓거. All rights reserved.
//

import Foundation
import UIKit

class SettingMainVC : UIViewController{
    
    @IBAction func logoutBtn(_ sender: Any) {
        let login_storyboard = UIStoryboard(name: "Login", bundle: nil)
        //메인 뷰컨트롤러 접근
        guard let splashVC = login_storyboard.instantiateViewController(withIdentifier: "SplashVC") as? SplashVC else {return}
        self.present(splashVC, animated: true)
    }
    
}
