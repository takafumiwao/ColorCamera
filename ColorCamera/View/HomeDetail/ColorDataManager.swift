//
//  ColorDataManager.swift
//  ColorCamera
//
//  Created by 岩男高史 on 2019/07/23.
//  Copyright © 2019 岩男高史. All rights reserved.
//

import UIKit
import Firebase

class ColorDataManager: NSObject {
    
    var temporaryColorArray:Array<Color> = []
    //エラーがあったら入れておく
    var myError:ColorError? = nil
    
    //delegate
    var delegate:ColorDataManagerDelegate? = nil
    
    //firebase
    let db = Firestore.firestore()
    //エラーの種類
    enum ColorError:Error {
        case communication
        case jsonParse
    }
    
    //読み込み処理
    func colorGet() {
        
        db.collection("home").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                self.delegate?.FirebaseReadError(error: err)
                return
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.data())")
                    //dataを取りだす
                    let doc = document.data()
                    let name = doc["name"] as! String
                    let rgb = doc["RGB"] as! [String]
                    let hsv = doc["HSV"] as! [String]
                    let hex = doc["HEX"] as! String
                    
                    let color = Color(name: name, rgb: rgb, hsv: hsv, hex: hex)
                    
                    self.temporaryColorArray.append(color)
                    
                }
            }
            //終わったことをメインキューで通知
            DispatchQueue.main.async {
                self.delegate?.FirebaseReadDidEnd(colorArray: self.temporaryColorArray)
            }
        }
    }
}
