//
//  DrawnResultVO.swift
//  chilDraw
//
//  Created by 갓거 on 2018. 4. 29..
//  Copyright © 2018년 갓거. All rights reserved.
//

import Foundation
import ObjectMapper

class DrawnResultVO : Mappable{
    var room_id: Int?
    var word: String?
    var draw: String?
    var draw_date: String?
    var score: Int?

    required init?(map: Map) {}
    
    func mapping(map: Map) {
        room_id <- map["room_id"]
        word <- map["word"]
        draw <- map["draw"]
        draw_date <- map["draw_date"]
        score <- map["score"]
    }
}
