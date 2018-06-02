//
//  DrawnMessageVO.swift
//  chilDraw
//
//  Created by 갓거 on 2018. 4. 29..
//  Copyright © 2018년 갓거. All rights reserved.
//

import Foundation
import ObjectMapper

class DrawnMessageVO: Mappable{
    var stat: String?
    var msg: String?
    var result: SettingResultVO?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        stat <- map["stat"]
        msg <- map["msg"]
        result <- map["result"]
    }
}
