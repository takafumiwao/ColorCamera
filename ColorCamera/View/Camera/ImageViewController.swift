//
//  ImageViewController.swift
//  ColorCamera
//
//  Created by 岩男高史 on 2019/07/28.
//  Copyright © 2019 岩男高史. All rights reserved.
//

import UIKit
import AVFoundation

class ImageViewController: UIViewController {
   
    //表示されている画像のタップ座標用変数
    var tapPoint = CGPoint(x: 0, y: 0)
    var originalTappoint = CGPoint(x: 0, y: 0)

    @IBOutlet weak var imageView: UIImageView!
    //前画面からimageを受け取る
    var image = UIImage()
    
    override func viewDidLoad() {
        
        imageView.frame.size = self.view.frame.size
        imageView.image = image

        //画像の縦横サイズ比率を変えずに制約を合わせる
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        let imageSize: CGSize
        //UIimageの向きによって縦横を変える
        switch image.imageOrientation.rawValue {
        case 3:
            imageSize = CGSize(width: image.size.height, height: image.size.width)
        default:
            imageSize = CGSize(width: image.size.width, height: image.size.height)
        }
        
        //uiimageViewのサイズを表示されている画像のサイズに合わせる
        if imageSize.width > imageSize.height {
            imageView.frame.size.height = imageSize.height/imageSize.width * imageView.frame.width
            
        } else {
            imageView.frame.size.width = imageSize.width/imageSize.height * imageView.frame.height
        }
        
        imageView.center = self.view.center
        
        self.view.addSubview(imageView)
        
        
    }
    
    @IBAction func getImageRGB(_ sender: UITapGestureRecognizer) {
        print("tap")
        guard imageView.image != nil else {return}
        
        //タップした座標の取得
        tapPoint = sender.location(in: imageView)
        //向きによって元の画像のタップ座標を変える(右に90°回転している場合)
        switch image.imageOrientation.rawValue {
        case 3:
            originalTappoint.x = image.size.height/imageView.frame.height * tapPoint.y
            originalTappoint.y = image.size.width - (image.size.width/imageView.frame.width * tapPoint.x)
            print("3")
            
        default:
            tapPoint.x = image.size.width/imageView.frame.width * tapPoint.x
            tapPoint.y = image.size.height/imageView.frame.height * tapPoint.y
            print("default")
        }
       
        
        let cgImage = imageView.image?.cgImage!
        let pixelData = cgImage?.dataProvider!.data
        let data: UnsafePointer = CFDataGetBytePtr(pixelData)
        //1ピクセルのバイト数
        let bytesPerPixel = (cgImage?.bitsPerPixel)! / 8
        //1ラインのバイト数
        let bytesPerRow = (cgImage?.bytesPerRow)!
    
        //タップした位置の座標にあたるアドレスを算出
        let pixelAd: Int = Int(originalTappoint.y) * bytesPerRow + Int(originalTappoint.x) * bytesPerPixel
        print(pixelAd)
        //それぞれのRGBAをとる
        let r = Int( CGFloat(data[pixelAd]))///CGFloat(255.0)*100)) / 100
        let g = Int( CGFloat(data[pixelAd+1]))///CGFloat(255.0)*100)) / 100
        let b = Int( CGFloat(data[pixelAd+2]))///CGFloat(255.0)*100)) / 100
        let a = CGFloat(Int( CGFloat(data[pixelAd+3])/CGFloat(255.0)*100)) / 100
        print(r,g,b,a)
        let intr = r
        let intg = g
        let intb = b
        let rtext = String(intr)
        let gtext = String(intg)
        let btext = String(intb)
    
        
        let storyboard:UIStoryboard = UIStoryboard(name: "ColorDetail", bundle: nil)
        let next = storyboard.instantiateViewController(withIdentifier: "ColorDetailViewController") as! ColorDetailViewController
        next.r = rtext
        next.g = gtext
        next.b = btext
        
        self.present(next, animated: true, completion: nil)
        
        
    }
}
