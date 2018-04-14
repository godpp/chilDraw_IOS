//
//  DrawVC.swift
//  chilDraw
//
//  Created by 갓거 on 2017. 12. 10..
//  Copyright © 2017년 갓거. All rights reserved.
//

import UIKit

class DrawVC: UIView, NetworkCallback {
    
    @IBOutlet var wordLabel : UILabel!
    @IBOutlet var goodJob_Img : UIImageView!
    @IBOutlet var exitBtn : UIButton!
    
    var delayInSeconds = 2.0
    var room_id:Int?
    var word:String?
    var category:Int?
    var arrNum:Int?
    var wordArr: String?
    var word_idArr : String?
    
    let user_token = UserDefaults.standard.string(forKey: "token")
    
    var drawViewVC : DrawViewVC?
    
    var result : Bool?
    var data : RandomMessageVO?
    
    func networkResult(resultData: Any, code: String) {
        print(code)
        if code == "result"{
            result = resultData as? Bool
            
            if result!{
                let model = MainModel(self)
                print(category)
                print(arrNum)
                print(wordArr!)
                print(user_token!)
                model.categoryChoiceModel(category: category! , arrNum: arrNum!, wordArr:  wordArr!,word_idArr: word_idArr!, token: user_token!)
            }
            else{
                print("오답")
            }
        }
        else if code == "success"{
            data = resultData as? RandomMessageVO
            room_id = data?.room_id!
            word = data?.word!
            print(word)
            arrNum = data?.arrNum!
            wordArr = data?.wordArr
            word_idArr = data?.word_idArr
            
            wordLabel.text! = word!
            goodJob_Img.isHidden = false
            erase()
           
            drawViewVC?.exitBtn(exitBtn)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds){
                self.goodJob_Img.isHidden = true
                
                
                
            }
        }
        else if code == "finish"{
            goodJob_Img.isHidden = false
            erase()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds){
                self.goodJob_Img.isHidden = true
                
                
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
        drawingArray.append(drawX)
        drawingArray.append(drawY)
        
        let model = MainModel(self)
        model.drawModel(draw: "\(drawingArray)", word: word!, room_id: room_id!, token: user_token!)
        print("\(drawingArray)")
        
        
        drawingArray.removeAll()
        
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
