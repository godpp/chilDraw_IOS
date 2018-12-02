//
//  DrawVC.swift
//  chilDraw
//
//  Created by 갓거 on 2017. 12. 10..
//  Copyright © 2017년 갓거. All rights reserved.
//


import UIKit
import Foundation
import AudioToolbox
import AMProgressBar

class DrawVC: UIView, NetworkCallback {
    
    @IBOutlet var wordLabel : UILabel!
    @IBOutlet var goodJob_Img : UIImageView!
    @IBOutlet var exitBtn : UIButton!
    @IBOutlet var wrong_Img : UIImageView!
    @IBOutlet var grayImageButton : UIButton!
    @IBOutlet var resultWordsLabel : UILabel!
    
    var delayInSeconds = 1.0
    var room_id:Int?
    var word:String?
    var category:Int?
    var arrNum:Int?
    var wordArr: String?
    var word_idArr : String?
    var word_idData: Int?
    var count: Int = 1
    
    let user_token = UserDefaults.standard.string(forKey: "token")
    
    var result : Bool?
    var data : RandomMessageVO?
    
    var TransferToServerTimer = Timer()
    
    var startTimer = Timer()

    
    override func awakeFromNib() {
        
        grayImageButton.isHidden = true
        grayImageButton.layer.cornerRadius = 10
        
        resultWordsLabel.text = ""
    }
    
    func stopTimer(){
        self.startTimer.invalidate()
    }
    
    @objc func autoTransferDrawingData() {
        grayImageButton.isHidden = false
        drawingArray.append(drawX)
        drawingArray.append(drawY)
        
        NotificationCenter.default.post(name: .networkingNoti, object: nil)
        resultWordsLabel.text = "인식중이에요. 멍!"
        if drawingArray.isEmpty == false{
            let model = MainModel(self)
            model.drawModel(
                draw: "\(drawingArray)",
                word: word!,
                room_id: room_id!,
                count: count,
                token: user_token!
            )
        }
        print(drawingArray)
        self.drawingArray.removeAll()
    }
    
    func networkResult(resultData: Any, code: String) {
        if code == "pack" {
            grayImageButton.isHidden = true
            let pack = resultData as? DrawTempVO
            let result: Bool = pack!.result!
            let counts: Int = pack!.count!
            NotificationCenter.default.post(name: .networkDoneNoti, object: nil)
            print(result)
            
            
            if result == true { // 정답
                count = 1
                let model = MainModel(self)
                model.categoryChoiceModel(
                    category: category!,
                    arrNum: arrNum!,
                    wordArr:  wordArr!,
                    word_idArr: word_idArr!,
                    token: user_token!
                )
                resultWordsLabel.text = ""
            }
            else{ // 오답
                count = counts + 1
                self.resultWordsLabel.text = "다시 그려보세요! 멍!"
                self.wrong_Img.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0){
                    self.resultWordsLabel.text = ""
                    self.wrong_Img.isHidden = true
                }
            }
        }
        // 다음문제 소환
        else if code == "success"{
            data = resultData as? RandomMessageVO
            room_id = data?.room_id!
            word = data?.word!
            arrNum = data?.arrNum!
            wordArr = data?.wordArr!
            word_idArr = data?.word_idArr!
            word_idData = data?.word_id!
            
            wordLabel.text! = word!
            grayImageButton.isHidden = false
            goodJob_Img.isHidden = false
            erase()

            
            //정답 표시
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds){
                self.grayImageButton.isHidden = true
                self.goodJob_Img.isHidden = true
            }
            
        }
        //카테고리 종료
        else if code == "finish"{
            erase()
            goodJob_Img.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds){
                NotificationCenter.default.post(name: .finish, object: nil)
            }
        }
        
    }
    
    func networkFailed() {}

    var isDrawing = false
    var lastPoint: CGPoint!
    var strokeColor: CGColor = UIColor.black.cgColor
    var strokes = [Stroke]()
    var timer : Timer?
    var startTime: Double = 0
    var time: Double = 0
    
    var drawingArray : [Array<Any>] = []
    var xArray : [Array<Any>] = []
    var yArray : [Array<Any>] = []
    var drawX : [Int] = []
    var drawY : [Int] = []
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isDrawing else { return }
        isDrawing = true
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        lastPoint = currentPoint
        
        self.stopTimer()
        
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDrawing else { return }
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        let stroke = Stroke(startPoint: lastPoint, endPoint: currentPoint, color: strokeColor)
        strokes.append(stroke)
        lastPoint = currentPoint
        drawX.append(Int(currentPoint.x))
        drawY.append(Int(self.frame.size.height - currentPoint.y))

        setNeedsDisplay()
        
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDrawing else { return }
        isDrawing = false
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        let stroke = Stroke(startPoint: lastPoint, endPoint: currentPoint, color: strokeColor)
        strokes.append(stroke)

        lastPoint = nil
        setNeedsDisplay()
        self.startTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(autoTransferDrawingData), userInfo: nil, repeats: false)
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(10)
        context?.setLineCap(.round)
        for stroke in strokes {
            context?.beginPath()
            context?.move(to: stroke.startPoint)
            context?.addLine(to: stroke.endPoint)
            context?.setStrokeColor(stroke.color)
            context?.strokePath()
        }
    }
    
    func erase() {
        resultWordsLabel.text = ""
        drawX.removeAll()
        drawY.removeAll()
        drawingArray.removeAll()
        strokes = []
        strokeColor = UIColor.black.cgColor
        setNeedsDisplay()
    }
}
