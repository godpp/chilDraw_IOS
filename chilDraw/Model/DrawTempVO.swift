//
//  DrawTempVO.swift
//  chilDraw
//
//  Created by 갓거 on 2018. 5. 3..
//  Copyright © 2018년 갓거. All rights reserved.
//

import Foundation
import ObjectMapper

class DrawTempVO : Mappable {
    var words : String?
    var result : Bool?
    var count: Int?
    
    required init?(map:Map){}
    
    func mapping(map: Map) {
        words <- map["words"]
        result <- map["result"]
        count <- map["count"]
    }
}
