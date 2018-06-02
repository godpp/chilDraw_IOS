//
//  MainModel.swift
//  chilDraw
//
//  Created by 갓거 on 2018. 2. 2..
//  Copyright © 2018년 갓거. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper


class MainModel : NetworkModel{
    
    func categoryChoiceModel(category : Int, arrNum : Int, wordArr : String,word_idArr : String, token : String){
        let URL : String = "\(baseURL)/game/imageList"
       
        let body : [String:Any] = [
            "category" : category,
            "arrNum" : arrNum,
            "wordArr" : wordArr,
            "word_idArr" : word_idArr
        ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ["user_token" : token]).responseObject{
            (response:DataResponse<RandomWordVO>) in
            switch response.result {
            case .success:
                guard let message = response.result.value else{
                    self.view.networkFailed()
                    return
                }
                
                if message.msg == "success"{
                    if let data = message.result{
                        self.view.networkResult(resultData: data, code: "success")
                    }
                }
                else if message.msg == "finish"{
                    if let finishmsg = message.msg{
                        self.view.networkResult(resultData: finishmsg, code: "finish")
                    }
                }
                else if message.msg == "5"{
                    self.view.networkResult(resultData: "기타오류(500)", code: "fail")
                }
            case .failure(let err):
                print(err)
                self.view.networkFailed()
            }
        }
    }
    
    func drawModel(draw: String, word: String, room_id: Int,count: Int, token: String){
        let URL : String = "\(baseURL)/game/imageTest"
        let body : [String:Any] = [
            "draw": draw,
            "word": word,
            "room_id": room_id,
            "count": count
        ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ["user_token" : token]).responseObject{
            (response:DataResponse<DrawVO>) in
            switch response.result {
            case .success:
                guard let message = response.result.value else{
                    self.view.networkFailed()
                    return
                }
                
                if message.msg == "success"{
                    if let pack = message.pack{
                        self.view.networkResult(resultData: pack, code: "pack")
                    }
                }
            case .failure(let err):
                print(err)
                self.view.networkFailed()
            }
        }
    }
    
    func recordModel(voice: Data?, token: String, fileName: String, word_id: Int) {
        let URL : String = "\(baseURL)/game/voice"
        
        let word_id = "\(word_id)".data(using: .utf8)
        
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(voice!, withName: "voice", fileName: fileName, mimeType: "audio/wav")
                multipartFormData.append(word_id!, withName: "word_id")
        },
            to: URL, method: .post, headers: ["user_token": token],
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseObject(completionHandler: { (response:DataResponse<VoiceResultVO>) in
                        switch response.result {
                            case .success:
                                guard let message = response.result.value else{
                                    self.view.networkFailed()
                                    return
                                }
                                
                                if message.msg == "success"{
                                    if let result = message.result{
                                        self.view.networkResult(resultData: result, code: "voice result")
                                    }
                                }
                                else if message.msg == "5"{
                                    
                                }
                            case .failure:
                                self.view.networkFailed()
                        }
                        
                    })
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
    }//Alamofire.upload
}
