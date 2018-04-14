//
//  MainVC.swift
//  chilDraw
//
//  Created by 갓거 on 2017. 11. 28..
//  Copyright © 2017년 갓거. All rights reserved.
//

import Foundation
import UIKit

class MainVC : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MyCellDelegate, NetworkCallback{
    
    @IBOutlet var categoryView: UICollectionView!
    
    var choiceCategoryNum : Int?
    let user_token = UserDefaults.standard.string(forKey: "token")
    var wordArr : String?
    var word_idArr : String?
    
    var categoryList = ["main_button_fruits.png","main_button_animals.png","main_button_object.png","main_button_clothes.png","main_button_nature.png","main_button_figure.png"]

    func categoryBtnPressed(cell: categoryCell) {
        //Get the indexpath of cell where button was tapped
        let indexPath = self.categoryView.indexPath(for: cell)
        choiceCategoryNum = gino(indexPath?.row) //넘버 아직 옵셔널 해제안됌.
        print(choiceCategoryNum)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryView.tintColor = UIColor.clear
        categoryView.backgroundColor = UIColor.clear

    }
    
    func networkResult(resultData: Any, code: String) {
        if code == "success"{
            
            let data = resultData as? RandomMessageVO
            print(data?.wordArr)
            print(data?.word_idArr)
            guard let drawviewVC = storyboard?.instantiateViewController(withIdentifier: "DrawViewVC") as? DrawViewVC else{
                return
            }
            if data?.arrNum != nil{
                
                drawviewVC.arrNumData = gino(data?.arrNum)
                drawviewVC.wordArr = data?.wordArr
                drawviewVC.word_idArr = data?.word_idArr
                drawviewVC.categoryNumData = gino(choiceCategoryNum)
                drawviewVC.wordData = gsno(data?.word)
                drawviewVC.room_idData = gino(data?.room_id)
                self.present(drawviewVC, animated: true)
            }
            else{
                simpleAlert(title: "네트워크 연결 오류", msg: "인터넷 연결을 확인하세요.")
            }
        }
    }
    
    func networkFailed() {
        simpleAlert(title: "네트워크 연결 오류", msg: "인터넷 연결을 확인하세요.")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = categoryView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! categoryCell
        cell.categoryBtn.setImage(UIImage(named: gsno(categoryList[indexPath.row])), for: .normal)
        cell.delegate = self
        return cell
    }
    
    @IBAction func startBtn(_ sender: Any) {
        let model = MainModel(self)
        model.categoryChoiceModel(category: gino(choiceCategoryNum), arrNum: -1, wordArr: gsno(wordArr), word_idArr: gsno(word_idArr), token: gsno(user_token))
    }
    
}
