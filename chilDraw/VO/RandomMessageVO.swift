//
//  RandomMessageVO.swift
//  chilDraw
//
//  Created by 갓거 on 2018. 4. 5..
//  Copyright © 2018년 갓거. All rights reserved.
//

import Foundation
import ObjectMapper

class RandomMessageVO : Mappable{
    var room_id : Int?
    var word_id : Int?
    var word : String?
    var arrNum : Int?
    var wordArr : String?
    var word_idArr : String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        room_id <- map["room_id"]
        word_id <- map["word_id"]
        word <- map["word"]
        arrNum <- map["arrNum"]
        wordArr <- map["wordArr"]
        word_idArr <- map["word_idArr"]
    }
}
