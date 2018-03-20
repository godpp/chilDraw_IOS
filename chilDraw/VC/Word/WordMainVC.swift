//
//  WordMainVC.swift
//  chilDraw
//
//  Created by 갓거 on 2017. 12. 10..
//  Copyright © 2017년 갓거. All rights reserved.
//

import Foundation
import UIKit

class WordMainVC : UIViewController{
    
    @IBAction func startBtn(_ sender: Any) {
        guard let wordviewVC = storyboard?.instantiateViewController(withIdentifier: "WordViewVC") as? WordViewVC else{
            return
        }
        self.present(wordviewVC, animated: true, completion: nil)
    }
    
}
