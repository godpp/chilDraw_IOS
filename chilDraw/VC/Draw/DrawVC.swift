//
//  DrawVC.swift
//  chilDraw
//
//  Created by 갓거 on 2017. 12. 10..
//  Copyright © 2017년 갓거. All rights reserved.
//

import UIKit
import Foundation


class DrawVC: UIView, NetworkCallback {
    
    @IBOutlet var wordLabel : UILabel!
    @IBOutlet var goodJob_Img : UIImageView!
    @IBOutlet var exitBtn : UIButton!
    @IBOutlet var wrong_Img : UIImageView!
    
    var delayInSeconds = 2.0
    var room_id:Int?
    var word:String?
    var category:Int?
    var arrNum:Int?
    var wordArr: String?
    var word_idArr : String?
    
    let user_token = UserDefaults.standard.string(forKey: "token")
    
    var result : Bool?
    var data : RandomMessageVO?
    
    var TransferToServerTimer = Timer()
    
    
    override func awakeFromNib() {
        TransferToServerTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(autoTransferDrawingData), userInfo: nil, repeats: true)
    }
    @objc func stopAutoTimer(){
        TransferToServerTimer.invalidate()
        
    }
    
    @objc func autoTransferDrawingData() {
        drawingArray.append(drawX)
        drawingArray.append(drawY)
        if drawingArray.isEmpty == false{
            print("호출!")
            let model = MainModel(self)
            model.drawModel(draw: "\(drawingArray)", word: word!, room_id: room_id!, token: user_token!)
            print(drawingArray)
        }
        self.drawingArray.removeAll()
    }
    
    func networkResult(resultData: Any, code: String) {
        print(code)
        if code == "result"{
            result = resultData as? Bool
            
            if result!{ // 정답
                let model = MainModel(self)
                model.categoryChoiceModel(category: category! , arrNum: arrNum!, wordArr:  wordArr!,word_idArr: word_idArr!, token: user_token!)
            }
            else{ // 오답
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds){
                    self.erase()
                    self.wrong_Img.isHidden = false
                }
                wrong_Img.isHidden = true
            }
        }
        // 다음문제 소환
        else if code == "success"{
            data = resultData as? RandomMessageVO
            room_id = data?.room_id!
            word = data?.word!
            arrNum = data?.arrNum!
            wordArr = data?.wordArr
            word_idArr = data?.word_idArr
            
            wordLabel.text! = word!
            goodJob_Img.isHidden = false
            erase()
            
            //정답 표시
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds){
                self.goodJob_Img.isHidden = true
            }
            
        }
        //카테고리 종료
        else if code == "finish"{
            erase()
            stopAutoTimer()
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
    var count = 0.0
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
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDrawing else { return }
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        let stroke = Stroke(startPoint: lastPoint, endPoint: currentPoint, color: strokeColor)
        strokes.append(stroke)
        lastPoint = currentPoint
        drawX.append(Int(currentPoint.x))
        drawY.append(Int(self.frame.size.height) - Int(currentPoint.y))
        
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
        drawX.removeAll()
        drawY.removeAll()
        drawingArray.removeAll()
        strokes = []
        strokeColor = UIColor.black.cgColor
        setNeedsDisplay()
    }
}
