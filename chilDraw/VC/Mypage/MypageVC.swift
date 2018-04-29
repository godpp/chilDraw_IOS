//
//  MypageVC.swift
//  chilDraw
//
//  Created by 갓거 on 2018. 4. 27..
//  Copyright © 2018년 갓거. All rights reserved.
//

import Foundation
import UIKit

class MypageVC : UIViewController{
    
    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func settingpageButton(_ sender: Any) {
        guard let settingpageVC = storyboard?.instantiateViewController(withIdentifier: "SettingPageVC") as? SettingPageVC
            else {return}
        self.present(settingpageVC, animated: true)
    }
    
}
