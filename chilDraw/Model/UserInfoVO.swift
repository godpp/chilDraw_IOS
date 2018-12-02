//
//  UserInfoVO.swift
//  chilDraw
//
//  Created by 갓거 on 2018. 4. 5..
//  Copyright © 2018년 갓거. All rights reserved.
//

import Foundation
import ObjectMapper

class UserInfoVO : Mappable {
    var email : String?
    var user_id : Int?
    var token : String?
    
    required init?(map:Map){}
    
    func mapping(map: Map) {
        email <- map["email"]
        user_id <- map["user_id"]
        token <- map["token"]
    }
}
