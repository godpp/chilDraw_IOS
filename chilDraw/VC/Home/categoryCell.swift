//
//  categoryCell.swift
//  chilDraw
//
//  Created by 갓거 on 2018. 4. 3..
//  Copyright © 2018년 갓거. All rights reserved.
//

import Foundation
import UIKit

protocol MyCellDelegate: AnyObject {
    func categoryBtnPressed(cell: categoryCell)
}

class categoryCell : UICollectionViewCell{
    
    weak var delegate: MyCellDelegate?
    @IBAction func categoryBtnPress(_ sender: Any) {
        delegate?.categoryBtnPressed(cell: self)
    }
    
    @IBOutlet var categoryBtn: UIButton!
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                super.isSelected = true
                self.categoryBtn.backgroundImage(for: .selected)
            }
            else
            {
                super.isSelected = false
                self.categoryBtn.backgroundImage(for: .normal)
            }
        }
    }
}
