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
    
    func drawModel(word: String, string: String){
        let URL : String = "\(baseURL)/image"
        let body : [String:String] = [
            "word": word,
            "string": string
        ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseObject{
            (response:DataResponse<DrawVO>) in
            switch response.result {
            case .success:
                guard let message = response.result.value else{
                    self.view.networkFailed()
                    return
                }
                
                if message.msg == "success"{
                    if let data = message.data{
                        self.view.networkResult(resultData: data, code: "1")
                    }
                }
            case .failure(let err):
                print(err)
                self.view.networkFailed()
            }
        }
    }
    
    func recordModel(voice: Data?) {
        let URL : String = "\(baseURL)/test"
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(voice!, withName: "voice", fileName: "voice.wav", mimeType: "audio/wav")
        },
            to: URL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseData { response in
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
    }//Alamofire.upload
}
