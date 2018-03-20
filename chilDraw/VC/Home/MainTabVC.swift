//
//  MainTabVC.swift
//  chilDraw
//
//  Created by 갓거 on 2017. 12. 10..
//  Copyright © 2017년 갓거. All rights reserved.
//

import Foundation
import UIKit

class MainTabVC : UITabBarController {
    
    override func viewDidLoad() {
        //UITabBar.appearance().backgroundColor = UIColor.clear
        UITabBar.appearance().barTintColor = UIColor.clear
        //UITabBar.appearance().tintColor = UIColor.clear
        var tabBar = self.tabBar
        
        var homeImage = UIImage(named:"main_home_button_home_on.png")?.withRenderingMode(.alwaysOriginal)
        var drawImg = UIImage(named: "main_home_draw_on-1.png")?.withRenderingMode(.alwaysOriginal)
        var wordImg = UIImage(named: "main_home_button_word_on.png")?.withRenderingMode(.alwaysOriginal)

        var settingImg = UIImage(named: "main_home_button_setting_on.png")?.withRenderingMode(.alwaysOriginal)

        (tabBar.items![0] as! UITabBarItem).selectedImage = homeImage
        (tabBar.items![1] as! UITabBarItem).selectedImage = drawImg
        (tabBar.items![2] as! UITabBarItem).selectedImage = wordImg
        (tabBar.items![3] as! UITabBarItem).selectedImage = settingImg
        
    }
    
    
}
