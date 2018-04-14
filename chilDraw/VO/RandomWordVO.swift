//
//  RandomWordVO.swift
//  chilDraw
//
//  Created by 갓거 on 2018. 4. 5..
//  Copyright © 2018년 갓거. All rights reserved.
//

import Foundation
import ObjectMapper

class RandomWordVO : Mappable {
    var msg : String?
    var result : RandomMessageVO?
    
    required init?(map:Map){}
    
    func mapping(map: Map) {
        result <- map["result"]
        msg <- map["msg"]
    }
}
