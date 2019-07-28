//
//  AuthViewController.swift
//  ColorCamera
//
//  Created by 岩男高史 on 2019/07/15.
//  Copyright © 2019 岩男高史. All rights reserved.
//

import UIKit
import FirebaseUI

class AuthViewController: UIViewController,FUIAuthDelegate {

    @IBOutlet weak var loginButton: UIButton!
    //認証変化の受け取り用オブジェクト
    var handle : AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    //画面表示直前でリスナーのアタッチ
    override func viewWillAppear(_ animated: Bool) {
        
        //認証状況確認にための処理をクロージャで指定する
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if user != nil {
                //サインインしている
                print("signInしています")
                
                //ログイン不要なので自動でアプリ画面まで進む
                //storyboardIDで遷移する
                let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
                let next: UIViewController = storyboard.instantiateInitialViewController() as! UIViewController
                self.present(next, animated: true, completion: nil)
                
            } else {
                //サインインしていない
                print("signInしていません")
            }
            
        }
    }
    
    //画面を閉じる直前にリスナーのデタッチ
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    //buttonをタップした時の処理
    @IBAction func tapLoginButton(_ sender: Any) {
        //認証用のUIの初期化
        let authUI = FUIAuth.defaultAuthUI()!
        //認証の状況を伝えてもらう
        authUI.delegate = self
        //認証方式は何も指定しないとメールなので、googleアカウント、匿名を追加
        let provider:[FUIAuthProvider] = [FUIGoogleAuth(),FUIAnonymousAuth(),FUIEmailAuth()]
        authUI.providers = provider
        
        //authUIが作ってくれたビューコントローラーを取得
        let authViewController = authUI.authViewController()
        //ログイン選択画面をだす
        self.present(authViewController, animated: true, completion: nil)
    }
    
    

}
