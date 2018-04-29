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
                    if let drawnList = message.result{
                        self.view.networkResult(resultData: drawnList, code: "success")
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
}
