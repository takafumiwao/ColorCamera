//
//  Color.swift
//  ColorCamera
//
//  Created by 岩男高史 on 2019/07/23.
//  Copyright © 2019 岩男高史. All rights reserved.
//

import UIKit

class Color:NSObject {
    
    //名前
    var name:String
    //rgb
    var rgb:[String]
    //hsv
    var hsv:[String]
    //hex
    var hex:String
    //path
    var path:String
    
    //イニシャライザ
    init(name:String, rgb:[String], hsv:[String], hex:String, path:String) {
        self.name = name
        self.rgb = rgb
        self.hsv = hsv
        self.hex = hex
        self.path = path
        super.init()
    }
    
}
