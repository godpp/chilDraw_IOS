//
//  SettingPageVC.swift
//  chilDraw
//
//  Created by 갓거 on 2018. 4. 27..
//  Copyright © 2018년 갓거. All rights reserved.
//

import Foundation
import UIKit

class SettingPageVC : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NetworkCallback{
    
    @IBOutlet var drawnCollectionView: UICollectionView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nicknameLabel: UILabel!
    
    var drawingList: [DrawnResultVO] = [DrawnResultVO]()
    let user_token = UserDefaults.standard.string(forKey: "token")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawnCollectionView.delegate = self
        drawnCollectionView.dataSource = self
        drawnCollectionView.tintColor = UIColor.clear
        drawnCollectionView.backgroundColor = UIColor.clear
    
    }
    override func viewWillAppear(_ animated: Bool) {
        let model = SettingModel(self)
        model.drawnLoadingModel(token: gsno(user_token))
    }
    
    func networkResult(resultData: Any, code: String) {
        if code == "success"{
            drawingList = resultData as! [DrawnResultVO]
            drawnCollectionView.reloadData()
        }
        else if code == "5"{
            let errormsg = resultData as? String
            simpleAlert(title: gsno(errormsg), msg: "관리자에게 문의하세요.")
        }
    }
    
    func networkFailed() {
        simpleAlert(title: "네트워크 오류", msg: "인터넷 연결을 확인하세요.")
    }
    
    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = drawnCollectionView.dequeueReusableCell(
            withReuseIdentifier: "drawnCell",
            for: indexPath
            ) as! drawnCell
        let row = drawingList[indexPath.row]
        cell.drawnImageView.imageFromUrl(gsno(row.draw), defaultImgPath: "")
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int {
        
        return drawingList.count
    }
}
