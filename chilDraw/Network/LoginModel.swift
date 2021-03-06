//
//  LoginModel.swift
//  chilDraw
//
//  Created by 갓거 on 2017. 12. 11..
//  Copyright © 2017년 갓거. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class LoginModel : NetworkModel{
    
    func login(email: String, pwd: String) {
        
        let URL = "\(baseURL)/users/login"
        let body : [String:String] = [
            "email": email,
            "pwd": pwd
        ]
        
        Alamofire.request(
            URL,
            method: .post,
            parameters: body,
            encoding: JSONEncoding.default,
            headers: nil
            ).responseObject{
            (response:DataResponse<LoginVO>) in
            switch response.result {
            case .success:
                guard let Message = response.result.value else{
                    self.view.networkFailed()
                    return
                }
                if Message.msg == "success" {
                    if let userInfo = Message.userInfo{
                        self.view.networkResult(resultData: userInfo, code: "1")
                    }
                }
                else {
                    self.view.networkResult(resultData: "error", code: "2")
                }
                
                
            case .failure(let err):
                print(err)
                self.view.networkFailed()
            }
        }
        
        
    }
}
