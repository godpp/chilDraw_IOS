//
//  SettingmainVO.swift
//  chilDraw
//
//  Created by 갓거 on 2018. 5. 3..
//  Copyright © 2018년 갓거. All rights reserved.
//

import Foundation
import ObjectMapper

class SettingResultVO: Mappable{
    var image: String?
    var nickname: String?
    var drawArr: [DrawnResultVO]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        image <- map["image"]
        nickname <- map["nickname"]
        drawArr <- map["drawArr"]
    }
}
