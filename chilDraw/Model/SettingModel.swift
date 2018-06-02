//
//  SettingModel.swift
//  chilDraw
//
//  Created by 갓거 on 2018. 4. 29..
//  Copyright © 2018년 갓거. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class SettingModel: NetworkModel{
    
    func drawnLoadingModel(token: String){
        let URL : String = "\(baseURL)/myPage/myDraw"
        
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["user_token" : token]).responseObject{
            (response:DataResponse<DrawnMessageVO>) in
            switch response.result {
            case .success:
                guard let message = response.result.value else{
                    self.view.networkFailed()
                    return
                }
                if message.msg == "success"{
                    if let result = message.result{
                        self.view.networkResult(resultData: result, code: "1")
                    }
                }
                else if message.msg == "5"{
                    self.view.networkResult(resultData: "기타 오류 (500)", code: "5")
                }
                
            case .failure(let err):
                print(err)
                self.view.networkFailed()
            }
        }
    }
    
    func nicknamechanginggModel(nickname: String, token: String){
        let URL : String = "\(baseURL)/myPage/nickChange"
        
        let body : [String:String] = [
            "nickname": nickname,
            ]
        
        Alamofire.request(
            URL,
            method: .post,
            parameters: body,
            encoding: JSONEncoding.default,
            headers: ["user_token" : token]
            ).responseObject{
            (response:DataResponse<JoinMessageVO>) in
            switch response.result {
            case .success:
                guard let message = response.result.value else{
                    self.view.networkFailed()
                    return
                }
                if message.msg == "success"{
                    self.view.networkResult(resultData: "닉네임 변경 성공!", code: "new nickname")
                }
                else if message.msg == "Duplicate nickname"{
                    self.view.networkResult(resultData: "닉네임 중복", code: "duplicate nickname")
                }
                
            case .failure(let err):
                print(err)
                self.view.networkFailed()
            }
        }
    }
    
    func profileImageChangingModel(image: Data?, token: String) {
        let URL : String = "\(baseURL)/myPage/imageChange"
        
        if image == nil{
            print("사진 파일이 없습니다.")
        }
        else{
            
            Alamofire.upload(multipartFormData : { multipartFormData in
                multipartFormData.append(image!, withName: "image", fileName: "image.jpg", mimeType: "image/png")
            },
                             to: URL, method: .post, headers: ["user_token": token],
                             encodingCompletion: { encodingResult in
                                
                                switch encodingResult{
                                case .success(let upload, _, _):
                                    upload.responseData { res in
                                        switch res.result {
                                        case .success:
                                            DispatchQueue.main.async(execute: {
                                                print("dispatc Queue")
                                                self.view.networkResult(resultData: "", code: "")
                                            })
                                        case .failure(let err):
                                            print("upload Error : \(err)")
                                            DispatchQueue.main.async(execute: {
                                                self.view.networkFailed()
                                            })
                                        }
                                    }
                                case .failure(let err):
                                    print("network Error : \(err)")
                                    self.view.networkFailed()
                                }//switch
            }
                
            )
        }
    }
    
    func graphModel(token: String){
        let URL : String = "\(baseURL)/myPage/myGraph"
        
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["user_token" : token]).responseObject{
            (response:DataResponse<GraphVO>) in
            switch response.result {
            case .success:
                guard let message = response.result.value else{
                    self.view.networkFailed()
                    return
                }
                if let result = message.result{
                        self.view.networkResult(resultData: result, code: "graphsuccess")
                        print(result)
                }
                else if message.msg == "fail"{
                    self.view.networkResult(resultData: "기타 오류 (500)", code: "graphfail")
                }
                
            case .failure(let err):
                print(err)
                self.view.networkFailed()
            }
        }
    }
    
}
