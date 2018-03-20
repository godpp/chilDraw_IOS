//
//  DrawMainVC.swift
//  chilDraw
//
//  Created by 갓거 on 2017. 12. 10..
//  Copyright © 2017년 갓거. All rights reserved.
//

import Foundation
import UIKit

class DrawMainVC : UIViewController{
    
    @IBAction func startBtn(_ sender: Any) {
        guard let drawviewVC = storyboard?.instantiateViewController(withIdentifier: "DrawViewVC") as? DrawViewVC else{
            return
        }
        self.present(drawviewVC, animated: true, completion: nil)
    }
}
