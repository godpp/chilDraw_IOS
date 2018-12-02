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
    var words : String?
    var msg : String?
    var pack: DrawTempVO?
    
    required init?(map:Map){}
    
    func mapping(map: Map) {
        words <- map["words"]
        msg <- map["msg"]
        pack <- map["pack"]
    }
}
