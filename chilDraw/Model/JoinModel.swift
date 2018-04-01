//
//  JoinModel.swift
//  chilDraw
//
//  Created by 갓거 on 2017. 12. 11..
//  Copyright © 2017년 갓거. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class JoinModel : NetworkModel{
    
    func duplicateEmail(email:String){
        let URL : String = "\(baseURL)/users/signup/email"
        
        let body = [
            "email" : email
            ] as [String : String]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default,
                          headers:nil).responseObject{
                            (response: DataResponse<JoinMessageVO>)in
                            
                            switch response.result{
                            case .success:
                                guard let message = response.result.value else{
                                    self.view.networkFailed()
                                    return
                                }
                                if message.msg == "email available"{
                                    self.view.networkResult(resultData: "이메일 사용가능", code: "dup_email_ok")
                                }
                                else if message.msg == "duplicate email"{
                                    self.view.networkResult(resultData: "전송 성공 시(201),중복일 때", code: "dup_email_fail")
                                }
                                else{
                                    self.view.networkResult(resultData: "기타오류", code: "3")
                                }
                                
                            case .failure(let err):
                                print(err)
                                self.view.networkFailed()
                            }
        }
    }
    
    func duplicateNickname(nickname:String){
        let URL : String = "\(baseURL)/users/signup/nickname"
        
        let body = [
            "nickname" : nickname
            ] as [String : String]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default,
                          headers:nil).responseObject{
                            (response: DataResponse<JoinMessageVO>)in
                            
                            switch response.result{
                            case .success:
                                guard let message = response.result.value else{
                                    self.view.networkFailed()
                                    return
                                }
                                if message.msg == "nickname available"{
                                    self.view.networkResult(resultData: "닉네임 사용가능", code: "dup_name_ok")
                                }
                                else if message.msg == "duplicate nickname"{
                                    self.view.networkResult(resultData: "전송 성공 시(201),중복일 때", code: "dup_name_fail")
                                }
                                else{
                                    self.view.networkResult(resultData: "기타오류", code: "3")
                                }
                                
                            case .failure(let err):
                                print(err)
                                self.view.networkFailed()
                            }
        }
    }
    
    func createMember(email:String, pwd:String, gender:String, nickname:String, age:Int){
        
        let URL : String = "\(baseURL)/users/signup"
        
        let body = [
            "email" : email,
            "pwd" : pwd,
            "gender" : gender,
            "nickname" : nickname,
            "age" : age
            ] as [String : Any]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding:JSONEncoding.default, headers:nil).responseObject{
            (response : DataResponse<JoinMessageVO>) in
            
            print(response.result)
            switch response.result{
                
            case .success:
                guard let message = response.result.value else{
                    self.view.networkFailed()
                    return
                }
                if message.msg == "1"{
                    self.view.networkResult(resultData: "전송 성공 시(200)", code: "1")
                }
                else if message.msg == "2"{
                    self.view.networkResult(resultData: "이메일 또는 닉네임 중복 시(401)", code: "2")
                }
                else if message.msg == "3"{
                    self.view.networkResult(resultData: "정보 미입력 시(401)", code: "3")
                }
                else if message.msg == "4"{
                    self.view.networkResult(resultData: "이메일, 패스워드 입력 조건 미 충족 시(401)", code: "4")
                }
                else if message.msg == "5"{
                    self.view.networkResult(resultData: "connection 오류 시(500)", code: "5")
                }
                else if message.msg == "6"{
                    self.view.networkResult(resultData: "hashing 오류 시(500)", code: "6")
                }
            case .failure(let err):
                print(err)
                self.view.networkFailed()
                
                
            }
            
        }
        
    }
}
