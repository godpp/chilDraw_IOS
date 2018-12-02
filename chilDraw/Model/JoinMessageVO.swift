//
//  JoinMessageVO.swift
//  chilDraw
//
//  Created by 갓거 on 2017. 12. 11..
//  Copyright © 2017년 갓거. All rights reserved.
//

import Foundation
import ObjectMapper

class JoinMessageVO : Mappable {
    var msg : String?
    
    required init?(map:Map){}
    
    func mapping(map: Map) {
        msg <- map["msg"]
    }
}
