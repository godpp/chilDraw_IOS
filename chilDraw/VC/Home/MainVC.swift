//
//  MainVC.swift
//  chilDraw
//
//  Created by 갓거 on 2017. 11. 28..
//  Copyright © 2017년 갓거. All rights reserved.
//

import Foundation
import UIKit

class MainVC : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,MyCellDelegate, NetworkCallback{
    
    @IBOutlet var categoryView: UICollectionView!
    
    var choiceCategoryNum : Int?
    let user_token = UserDefaults.standard.string(forKey: "token")
    var wordArr : String?
    var word_idArr : String?
    var result: [Double] = []
    
    var categoryList = [
        "main_button_fruits.png",
        "main_button_animals.png",
        "main_button_object.png",
        "main_button_clothes.png",
        "main_button_nature.png",
        "main_button_figure.png"
    ]
    
    var pressButtonImageList = [
        "main_button_fruits_click.png",
        "main_button_animals_click.png",
        "main_button_object_click.png",
        "main_button_clothes_click.png",
        "main_button_nature_click.png",
        "main_button_figure_click.png"
    ]

    // 카테고리 클릭시 해당 값 호출
    func categoryBtnPressed(cell: categoryCell) {
        let indexPath = self.categoryView.indexPath(for: cell)
        choiceCategoryNum = gino(indexPath?.row)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryView.tintColor = UIColor.clear
        categoryView.backgroundColor = UIColor.clear
        
        self.categoryView.allowsMultipleSelection = false
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        let model = SettingModel(self)
//        model.graphModel(token: gsno(user_token))
//    }
    
    func networkResult(resultData: Any, code: String) {
        print(code)
        // 그림 그리기 시작!
//        if code == "graphsuccess"{
//            result = resultData as! [Double]
//        }
//        else if code == "graphfail"{
//
//        }

        if code == "success"{
            
            let data = resultData as? RandomMessageVO
            
            if gino(choiceCategoryNum) == 1{
                guard let voiceVC = storyboard?.instantiateViewController(
                    withIdentifier: "VoiceVC"
                    ) as? VoiceVC
                    else{return}
                if data?.arrNum != nil{
                    
                    voiceVC.word_idData = gino(data?.word_id)
                    voiceVC.arrNumData = gino(data?.arrNum)
                    voiceVC.wordArr = data?.wordArr
                    voiceVC.word_idArr = data?.word_idArr
                    voiceVC.categoryNumData = gino(choiceCategoryNum)
                    voiceVC.wordData = gsno(data?.word)
                    voiceVC.room_idData = gino(data?.room_id)
                    self.present(voiceVC, animated: true)
                }
                else{
                    simpleAlert(title: "네트워크 연결 오류", msg: "인터넷 연결을 확인하세요.")
                }
            }
            else{
                guard let drawviewVC = storyboard?.instantiateViewController(
                    withIdentifier: "DrawViewVC"
                    ) as? DrawViewVC
                    else{return}
                if data?.arrNum != nil{
                    
                    drawviewVC.word_idData = gino(data?.word_id)
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
    }
    
    func networkFailed() {
        simpleAlert(title: "네트워크 연결 오류", msg: "인터넷 연결을 확인하세요.")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int {
        return categoryList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        
        let cell = categoryView.dequeueReusableCell(
            withReuseIdentifier: "categoryCell",
            for: indexPath
            ) as! categoryCell
        cell.isSelected = false
        cell.categoryBtn.setBackgroundImage(UIImage(named: gsno(categoryList[indexPath.row])), for: .normal)
        
        cell.delegate = self
        return cell
    }

    
    @IBAction func startBtn(_ sender: Any) {
        let model = MainModel(self)
        model.categoryChoiceModel(
            category: gino(choiceCategoryNum),
            arrNum: -1,
            wordArr: gsno(wordArr),
            word_idArr: gsno(word_idArr),
            token: gsno(user_token)
        )
    }
    
    @IBAction func helppageButton(_ sender: Any) {
        guard let helppageVC = storyboard?.instantiateViewController(
            withIdentifier : "HelpPageVC"
            ) as? HelpPageVC
            else{return}
        self.present(helppageVC, animated: true)
        
    }
    @IBAction func mypageButton(_ sender: Any) {
//        guard let mypageVC = storyboard?.instantiateViewController(
//            withIdentifier: "MypageVC"
//            ) as? MypageVC
//            else {return}
//        mypageVC.result = result
//        self.present(mypageVC, animated: true)
        guard let settingpageVC = storyboard?.instantiateViewController(
            withIdentifier: "SettingPageVC"
            ) as? SettingPageVC
            else {return}
        self.present(settingpageVC, animated: true)
    }
    
}
