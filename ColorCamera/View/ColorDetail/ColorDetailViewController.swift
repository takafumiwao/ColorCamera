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
import LINEActivity

class ColorDetailViewController: UIViewController,UITextFieldDelegate {
    
   
    //storyboard紐付け
    @IBOutlet weak var imageView: UIImageView!
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
    var count:Int?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.configureObserver()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
      self.colorText.delegate = self
      self.rLabel.text = self.r
      self.gLabel.text = self.g
      self.bLabel.text = self.b
      let r = CGFloat(Int(self.r)!)
      let g = CGFloat(Int(self.g)!)
      let b = CGFloat(Int(self.b)!)
      let rInt = Int(self.r)!
      let gInt = Int(self.g)!
      let bInt = Int(self.b)!
      let hsv = fromRGB(red: rInt, green: gInt, blue: bInt)
      let h = Int(hsv.hue)
      let s = Int(hsv.saturation)
      let v = Int(hsv.value)
      self.hLabel.text = String(h)
      self.sLabel.text = String(s)
      self.vLabel.text = String(v)
      let hex = rgbToHex(r: rInt, g: gInt, b: bInt)
      self.hexLabel.text = hex
      

      
      
      self.imageView.backgroundColor = UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.removeObserver()
    }
    
    func fromRGB(red:Int, green:Int, blue:Int) -> HSV {
        let r = Double(red) / 255
        let g = Double(green) / 255
        let b = Double(blue) / 255
        
        let maxValue = max(max(r, g), b)
        let minValue = min(min(r, g), b)
        let sub = maxValue - minValue
        
        var h: Double = 0
        var s: Double = 0
        var v: Double = 0
        
        if sub == 0 {
            h = 0
        } else {
            if (maxValue == r) {
                h = (60 * (g - b) / sub) + 0
            } else if (maxValue == g) {
                h = (60 * (b - r) / sub) + 120
            } else if (maxValue == b) {
                h = (60 * (r - g) / sub) + 240
            }
            
            if (h < 0) {
                h += 360
            }
        }
        
        if (maxValue > 0) {
            
            s = sub / maxValue * 100
            
        }
        
        v = maxValue * 100
        
        return HSV(hue: floor(h), saturation: floor(s), value: floor(v))
    }
    
    //RGBからhexへ変換
    func rgbToHex(r:Int,g:Int,b:Int) -> String {
        return String(NSString(format: "%02X%02X%02X", r,g,b))
    }

    
    //cameraViewへ遷移
    @IBAction func tapCameraButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Camera", bundle: nil)
        let next: UIViewController = storyboard.instantiateInitialViewController() as! UIViewController
        self.present(next, animated: true, completion: nil)
    }
    
    
    
    @IBAction func homeSaveButton(_ sender: Any) {
        
        if colorText.text == "" {
            SCLAlertView().showEdit("名無し", subTitle: "色に名前をつけましょう！")
        } else {
        
        
        //ユーザー情報を取得
        let user = Auth.auth().currentUser
        let userId = user?.uid
        let db = Firestore.firestore()
        
        db.collection("myListCount").document("\(userId!)").getDocument { (snapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
        
            }
            
            if let data = snapshot?.data() {
                let count = data["count"] as! Int
                self.count = count + 1
                
            } else {
                self.count = 1
            }
            
            db.collection("myListCount").document("\(userId!)").setData(["count":self.count!], completion: { (err) in
                if let erorr = err {
                    print("\(erorr.localizedDescription)")
                }
            })
            
            let data = [
                "name": self.colorText.text!,
                "RGB":[self.rLabel.text,self.gLabel.text,self.bLabel.text],
                "HSV":[self.hLabel.text,self.sLabel.text,self.vLabel.text],
                "HEX": self.hexLabel.text!
                ]  as [String : Any]
            
            //firebaseにとうろく
            db.collection("\(userId!)").document("\(self.count!)").setData(data)
            db.collection("home").document().setData(data)
           
           
        }
            DispatchQueue.main.async {
              
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                let alertView = SCLAlertView(appearance: appearance)
                alertView.showTitle("", subTitle: "登録しました", style: .success)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                    let storyboard: UIStoryboard = UIStoryboard(name: "Camera", bundle: nil)
                    let next: UIViewController = storyboard.instantiateInitialViewController() as! UIViewController
                    self.present(next, animated: true, completion: nil)
                })
               
                
            
            }
            
          
           
        }
        
        
    }
    
    @objc func gohome() {
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //notificationを設定
    func configureObserver() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notication:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //notificationを削除
    func removeObserver() {
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    
    //keyboardが現れた時に、画面全体をずらす
    @objc func keyboardWillShow(notification: Notification?) {
        let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: {
            () in
            let transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
            self.view.transform = transform
        })
        
    }
    
    //keyboardが消えた時に、画面を戻す
    @objc func keyboardWillHide(notication: Notification?) {
        let duration: TimeInterval? = notication?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!) {
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    
    
    @IBAction func tapairdrop(_ sender: Any) {
        
        //共有する項目
        let shareRGB = "R:\(rLabel.text!),G:\(gLabel.text!),B:\(bLabel.text!)\nH:\(hLabel.text!),S:\(sLabel.text!),V:\(vLabel.text!)\nHEX:\(hexLabel.text!)"
    
        //LINEを追加する
        let LineKit = LINEActivity()
        let myApplicationActivities = [LineKit]
        
        let activityItems = [shareRGB]
        
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
    
    @objc func home() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Camera", bundle: nil)
        let next: UIViewController = storyboard.instantiateInitialViewController() as! UIViewController
        self.present(next, animated: true, completion: nil)
    }
}
