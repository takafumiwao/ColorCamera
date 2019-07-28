//
//  ColorDataManager.swift
//  ColorCamera
//
//  Created by 岩男高史 on 2019/07/23.
//  Copyright © 2019 岩男高史. All rights reserved.
//

import UIKit

protocol ColorDataManagerDelegate {
    //Firebase読み込みが終わった時
    func FirebaseReadDidEnd(colorArray:[Color])
    
    //myList読み込み終わった時
    func myListCountReadDidEnd(myListCount:Int)
    
    //Firebase読み込みエラーの時
    func FirebaseReadError(error:Error)
}
