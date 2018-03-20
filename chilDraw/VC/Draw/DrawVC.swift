//
//  DrawVC.swift
//  chilDraw
//
//  Created by 갓거 on 2017. 12. 10..
//  Copyright © 2017년 갓거. All rights reserved.
//

import UIKit

class DrawVC: UIView, NetworkCallback {
    
    var data : Int = 0
    
    
    func networkResult(resultData: Any, code: String) {
        if code == "1"{
            data = resultData as! Int
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
        model.drawModel(word: "grape", string: "\(drawingArray)")
        print("\(drawingArray)")
        drawingArray.removeAll()
        print(data)
        if data == 1{
            print("정답")
        }
        else{
            print("오답")
        }
        
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
