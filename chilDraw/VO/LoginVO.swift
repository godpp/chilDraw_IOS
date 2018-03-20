//
//  LoginVO.swift
//  chilDraw
//
//  Created by 갓거 on 2017. 12. 11..
//  Copyright © 2017년 갓거. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginVO : Mappable {
    var data : String?
    var msg : String?
    
    required init?(map:Map){}
    
    func mapping(map: Map) {
        data <- map["data"]
        msg <- map["msg"]
    }
}
