//
//  DrawViewVC.swift
//  chilDraw
//
//  Created by 갓거 on 2017. 12. 10..
//  Copyright © 2017년 갓거. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AMProgressBar

extension Notification.Name{
    static let finish = Notification.Name("finish")
    static let networkingNoti = Notification.Name("networkingNoti")
    static let networkDoneNoti = Notification.Name("networkDoneNoti")
}


class DrawViewVC : UIViewController, AVAudioRecorderDelegate, NetworkCallback{
    
    @IBOutlet var goodjob_ImgView: UIImageView!
    @IBOutlet var drawView: DrawVC!
    @IBOutlet var helpPageImgView: UIButton!
    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var clearImageView: UIButton!
    @IBOutlet var progressBar: AMProgressBar!
    
    @IBOutlet var eraseButton: UIButton!
    
    var delayInSeconds = 2.0
    var recordingTime = 2.0

    let user_token = UserDefaults.standard.string(forKey: "token")
    var wordData : String?
    var categoryNumData : Int?
    var arrNumData : Int?
    var wordArr : String?
    var word_idArr : String?
    var room_idData : Int?
    var word_idData : Int?
    
    var audioNum : Int = 1
    var voiceresult : Bool?
    
    // 카테고리 종료 Notification 알림
    @objc func ParentDismiss(notification: NSNotification){
        clearImageView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds){
            NotificationCenter.default.removeObserver(self)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // 네트워킹 인식중 알림
    @objc func networkingFiveSeconds(notification: NSNotification){
        eraseButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.progressBar.setProgress(progress: 0.33, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.progressBar.setProgress(progress: 0.72, animated: true)
        }
    }
    
    // 네트워킹 인식끝 알림
    @objc func networkingDone(notification: NSNotification){
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.progressBar.setProgress(progress: 1, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.progressBar.setProgress(progress: 0, animated: true)
        }
        eraseButton.isEnabled = true
    }
    
    @IBAction func exitBtn(_ sender: Any) {
        NotificationCenter.default.removeObserver(self)
        self.dismiss(animated: true)
    }
    
    @IBAction func onEraseTapped(_ sender: Any) {
        drawView.erase()
    }
    
    func networkFailed() {
        simpleAlert(title: "네트워크 오류", msg: "인터넷 연결을 확인해주세요!")
    }
    
    func networkResult(resultData: Any, code: String) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        clearImageView.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.helpPageImgView.isHidden = true
        }
        
        // 카테고리 종료 알림
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ParentDismiss(notification:)),
            name: .finish,
            object: nil
        )

        
        // 네트워크 통신 5초 progress 알림
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkingFiveSeconds),
            name: .networkingNoti,
            object: nil
        )
        
        // 네트워크 통신 종료 알림
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkingDone(notification:)),
            name: .networkDoneNoti,
            object: nil
        )
        
        //문제 단어 설정
        wordLabel.text = gsno(wordData)
        
        //DrawVC로 값 전달
        drawView.room_id = gino(room_idData)
        drawView.word = gsno(wordData)
        drawView.category = gino(categoryNumData)
        drawView.arrNum = gino(arrNumData)
        drawView.wordArr = gsno(wordArr)
        drawView.word_idArr = gsno(word_idArr)
    }
    
}
