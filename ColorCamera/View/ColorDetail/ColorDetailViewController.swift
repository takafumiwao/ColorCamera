//
//  ColorDetailViewController.swift
//  ColorCamera
//
//  Created by 岩男高史 on 2019/07/15.
//  Copyright © 2019 岩男高史. All rights reserved.
//

import UIKit
import SCLAlertView
import Firebase

class ColorDetailViewController: UIViewController {
    
    //storyboard紐付け
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var colorText: UITextField!
    @IBOutlet weak var rLabel: UILabel!
    @IBOutlet weak var gLabel: UILabel!
    @IBOutlet weak var bLabel: UILabel!
    @IBOutlet weak var hLabel: UILabel!
    @IBOutlet weak var sLabel: UILabel!
    @IBOutlet weak var vLabel: UILabel!
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var buckButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    var color: UIColor!
    var r:String!
    var g:String!
    var b:String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
      self.rLabel.text = self.r
      self.gLabel.text = self.g
      self.bLabel.text = self.b
      let r = CGFloat(Int(self.r)!)
      let g = CGFloat(Int(self.g)!)
      let b = CGFloat(Int(self.b)!)
      self.imageView.backgroundColor = UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    //cameraViewへ遷移
    @IBAction func tapCameraButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Camera", bundle: nil)
        let next: UIViewController = storyboard.instantiateInitialViewController() as! UIViewController
        self.present(next, animated: true, completion: nil)
    }
    
    
    
    @IBAction func homeSaveButton(_ sender: Any) {
        
        SCLAlertView().showTitle("ok", subTitle: "ok", timeout: SCLAlertView.SCLTimeoutConfiguration.init(timeoutValue: 1.0, timeoutAction: {
            print("ok")
        }), completeText: "ok", style: .success, colorStyle: 0xFFFF00, colorTextButton: 0x000000, circleIconImage: UIImage(named: "colorCamera"), animationStyle: .bottomToTop)
        //ユーザー情報を取得
        let user = Auth.auth().currentUser
        let userId = user?.uid
        let db = Firestore.firestore()
        
//        db.collection("myListCount").document("\(userId!)").getDocument { (snapshot, error) in
//            if let error = error {
//                print("\(error.localizedDescription)")
//                self.count = 1
//            }
//
//            if let data = snapshot?.data() {
//                let count = data["count"] as! Int
//                self.count = count + 1
//
//            } else {
//                self.count = 1
//            }
//
//            self.db.collection("myListCount").document("\(userId!)").setData(["count":self.count!], completion: { (err) in
//                if let erorr = err {
//                    print("\(erorr.localizedDescription)")
//                }
//            })
//
//            let data = [
//                "name": self.color!.name,
//                "RGB":["\(self.color!.rgb[0])","\(self.color!.rgb[1])","\(self.color!.rgb[2])"],
//                "HSV":["\(self.color!.hsv[0])","\(self.color!.hsv[1])","\(self.color!.hsv[2])"],
//                "HEX": self.color!.hex
//                ]  as [String : Any]
//
//            //firebaseにとうろく
//            self.db.collection("\(userId!)").document("\(self.count!)").setData(data)
        
//        }
        
        
    }
    
}
