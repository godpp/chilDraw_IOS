//
//  DrawVO.swift
//  chilDraw
//
//  Created by 갓거 on 2018. 2. 4..
//  Copyright © 2018년 갓거. All rights reserved.
//

import Foundation
import ObjectMapper

class DrawVO : Mappable {
    var data : Int?
    var msg : String?
    
    required init?(map:Map){}
    
    func mapping(map: Map) {
        data <- map["data"]
        msg <- map["msg"]
    }
}
