//
//  GraphVO.swift
//  chilDraw
//
//  Created by 갓거 on 2018. 5. 24..
//  Copyright © 2018년 갓거. All rights reserved.
//

import Foundation
import ObjectMapper

class GraphVO: Mappable{
    var msg: String?
    var result: [Double]?
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        msg <- map["msg"]
        result <- map["result"]
    }
}
