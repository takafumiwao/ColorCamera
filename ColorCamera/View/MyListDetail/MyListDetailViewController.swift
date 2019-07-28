//
//  MyListDetailViewController.swift
//  ColorCamera
//
//  Created by 岩男高史 on 2019/07/15.
//  Copyright © 2019 岩男高史. All rights reserved.
//

import UIKit
import Accounts
import LINEActivity

class MyListDetailViewController: UIViewController {
    
    var color: Color?
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
    @IBOutlet weak var actionButton: UIBarButtonItem!
    

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
    
    //airdropの処理
    @IBAction func tapActionButton(_ sender: Any) {
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
    
    //myListViewへ遷移
    @IBAction func tapListView(_ sender: Any) {
        
//        let storyboard:UIStoryboard = UIStoryboard(name: "MyList", bundle: nil)
//        let next:UIViewController = storyboard.instantiateInitialViewController() as! UIViewController
//        self.present(next,animated: true,completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    

}
