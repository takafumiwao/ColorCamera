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
    var myListCount:Int?
    //エラーがあったら入れておく
    var myError:ColorError? = nil
    
    //delegate
    var delegate:ColorDataManagerDelegate? = nil
    
    //firebase
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    var snapshot: ListenerRegistration! = nil
    //エラーの種類
    enum ColorError:Error {
        case communication
        case jsonParse
    }
    
    //Home読み込み処理
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
                    let paht = document.reference.documentID
                    let doc = document.data()
                    let name = doc["name"] as! String
                    let rgb = doc["RGB"] as! [String]
                    let hsv = doc["HSV"] as! [String]
                    let hex = doc["HEX"] as! String
                    
                    let color = Color(name: name, rgb: rgb, hsv: hsv, hex: hex, path:paht)
                    
                    self.temporaryColorArray.append(color)
                    print("OK")
                    
                }
            }
            //終わったことをメインキューで通知
            DispatchQueue.main.async {
                self.delegate?.FirebaseReadDidEnd(colorArray: self.temporaryColorArray)
            }
        }

    }
    
    //MyList読み込み処理
    func myListColorGet() {
        //ユーザー情報を得る
        let user = Auth.auth().currentUser
        let userId = user?.uid
        print("\(userId!)")

        db.collection("\(userId!)").getDocuments { (document, err) in
            if let error = err {
                print("\(error)")
                self.delegate?.FirebaseReadError(error: error)
                return
            } else {
                
            
                    //dataを取りだす
                for document in document!.documents {
                    print("\(document.data())")
                let path = document.reference.documentID
                    let document = document.data()
                let name = document["name"] as! String
                let rgb = document["RGB"] as! [String]
                let hsv = document["HSV"] as! [String]
                let hex = document["HEX"] as! String
                
                    
                    let color = Color(name: name, rgb: rgb, hsv: hsv, hex: hex, path: path)
                    self.temporaryColorArray.append(color)
                }
                    
                
                
            }
            //終わったことをメインキューで通知
            DispatchQueue.main.async {
                self.delegate?.FirebaseReadDidEnd(colorArray: self.temporaryColorArray)
            }
        }
    }
    
    //myListCount読み込み処理
    func myListCountGet() {
        //ユーザー情報を得る
        let user = Auth.auth().currentUser
        let userId = user!.uid
        
        db.collection("MyListCount").document("\(userId)").getDocument { (snapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                self.myListCount = 0
            }
            
            if let data = snapshot?.data() {
                let count = data["count"] as! Int
                self.myListCount = count
            }
            
            self.myListCount = 0
            
            DispatchQueue.main.async {
                self.delegate?.myListCountReadDidEnd(myListCount:self.myListCount!)
            }
        }
    }
}


