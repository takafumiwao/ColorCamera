//
//  HomeDetailViewController.swift
//  ColorCamera
//
//  Created by 岩男高史 on 2019/07/15.
//  Copyright © 2019 岩男高史. All rights reserved.
//

import UIKit
import LINEActivity
import Firebase
import KRProgressHUD
import SCLAlertView

class HomeDetailViewController: UIViewController {

    //前の画面からセットしてもらう
    var color:Color?
    var count:Int?
    //storyboardに紐付け
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var colorText: UITextField!
    //RGB
    @IBOutlet weak var rLabel: UILabel!
    @IBOutlet weak var gLabel: UILabel!
    @IBOutlet weak var bLabel: UILabel!
    //HSV
    @IBOutlet weak var hLabel: UILabel!
    @IBOutlet weak var sLabel: UILabel!
    @IBOutlet weak var vLabel: UILabel!
    //HEX
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var toolBar: UIToolbar!
    //button
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    //firebase
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let color = color else {
            return
        }
        
        let rColorInt = Int(color.rgb[0])!
        let gColorInt = Int(color.rgb[1])!
        let bColorInt = Int(color.rgb[2])!
        let rColor = CGFloat(rColorInt)
        let gColor = CGFloat(gColorInt)
        let bColor = CGFloat(bColorInt)
    
        imageView.backgroundColor = UIColor(red: rColor/255, green: gColor/255, blue: bColor/255, alpha: 1)
        
        if imageView.backgroundColor == UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1) {
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.borderWidth = 10
        }
        
        rLabel.text = color.rgb[0]
        gLabel.text = color.rgb[1]
        bLabel.text = color.rgb[2]
        
        hLabel.text = color.hsv[0]
        sLabel.text = color.hsv[1]
        vLabel.text = color.hsv[2]
        
        hexLabel.text = color.hex
        
        
    }
    
    
    @IBAction func tapHomeButton(_ sender: Any) {
        
       dismiss(animated: true, completion: nil)
    }
    
    
    //airdropの処理
    @IBAction func tapAirDrop(_ sender: Any) {
        
        //共有する項目
        let shareRGB = "111"
        let shareHSV = NSURL(string: "HSV")!
        let hex = "123456"
        let shareImage = UIImage(named: "home")!
        
        //LINEを追加する
        let LineKit = LINEActivity()
        let myApplicationActivities = [LineKit]
        
        let activityItems = [shareRGB, shareHSV, hex, shareImage] as [Any]
        
        //初期化処理
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: myApplicationActivities)
        
        //使用しないアクティビティタイプ
        let excludedActivityTypes = [
            UIActivity.ActivityType.postToFacebook,
            UIActivity.ActivityType.saveToCameraRoll
        ]
        
        activityVC.excludedActivityTypes = excludedActivityTypes
        
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    
    //お気に入りに追加の処理
    @IBAction func tapFavorite(_ sender: Any) {
        
        SCLAlertView().showTitle("ok", subTitle: "ok", timeout: SCLAlertView.SCLTimeoutConfiguration.init(timeoutValue: 1.0, timeoutAction: {
            print("ok")
        }), completeText: "ok", style: .success, colorStyle: 0xFFFF00, colorTextButton: 0x000000, circleIconImage: UIImage(named: "colorCamera"), animationStyle: .bottomToTop)
        //ユーザー情報を取得
        let user = Auth.auth().currentUser
        let userId = user?.uid
        
        db.collection("myListCount").document("\(userId!)").getDocument { (snapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                self.count = 1
            }
        
            if let data = snapshot?.data() {
                let count = data["count"] as! Int
                self.count = count + 1
            
            } else {
                self.count = 1
            }
            
            self.db.collection("myListCount").document("\(userId!)").setData(["count":self.count!], completion: { (err) in
                if let erorr = err {
                    print("\(erorr.localizedDescription)")
                }
            })
            
            let data = [
                "name": self.color!.name,
                "RGB":["\(self.color!.rgb[0])","\(self.color!.rgb[1])","\(self.color!.rgb[2])"],
                "HSV":["\(self.color!.hsv[0])","\(self.color!.hsv[1])","\(self.color!.hsv[2])"],
                "HEX": self.color!.hex
                ]  as [String : Any]
            
            //firebaseにとうろく
            self.db.collection("\(userId!)").document("\(self.count!)").setData(data)
            
        }
        
        
        
        
    }
    
    @objc func get() {
        
    }
    

}


