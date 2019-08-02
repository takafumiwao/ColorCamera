//
//  CameraViewController.swift
//  ColorCamera
//
//  Created by 岩男高史 on 2019/07/15.
//  Copyright © 2019 岩男高史. All rights reserved.
//

import UIKit
import SwiftyCam

class CameraViewController: SwiftyCamViewController,SwiftyCamViewControllerDelegate {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var shootingButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraDelegate = self
        cameraView.backgroundColor = UIColor.clear
        swipeToZoom = true
        pinchToZoom = true
        // Do any additional setup after loading the view.
    }
    
    //HomeViewControllerへ遷移
    @IBAction func tapHomeButton(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let next: UIViewController = storyboard.instantiateInitialViewController() as! UIViewController
        self.present(next,animated: true,completion: nil)
       
    }
    
    //swicthButtonをtap
    @IBAction func tapswitchButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let next = storyboard.instantiateViewController(withIdentifier: "myList") as! MyListViewController
        let navigationController = UINavigationController(rootViewController: next)
        navigationController.popViewController(animated: true)
        self.present(navigationController,animated: true,completion: nil)
    }
    
    //撮影の処理を書く
    @IBAction func tapShootingButtonn(_ sender: Any) {
        takePhoto()
        
    }
    
    //写真撮影をする時のメソッド
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        print("shoot")
        
        let storyboard: UIStoryboard = self.storyboard!
        let next = storyboard.instantiateViewController(withIdentifier: "image") as! ImageViewController
        next.image = photo
        
        self.present(next, animated: true, completion: nil)
        
    }
    
    

}

