//
//  WordViewVC.swift
//  chilDraw
//
//  Created by 갓거 on 2017. 12. 10..
//  Copyright © 2017년 갓거. All rights reserved.
//

import Foundation
import UIKit

class WordViewVC : UIViewController{
    @IBOutlet var drawView: DrawVC!
    
    @IBAction func exitBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onEraseTapped(_ sender: Any) {
        drawView.erase()
    }
    
    
    @IBAction func onRedTapped(_ sender: Any) {
        drawView.strokeColor = UIColor.red.cgColor
    }
    
    
    @IBAction func onBlueTapped(_ sender: Any) {
        drawView.strokeColor = UIColor.blue.cgColor
    }
    
    @IBAction func onGreenTapped(_ sender: Any) {
        drawView.strokeColor = UIColor.green.cgColor
    }
}
