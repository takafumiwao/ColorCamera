//
//  MyListViewController.swift
//  ColorCamera
//
//  Created by 岩男高史 on 2019/07/15.
//  Copyright © 2019 岩男高史. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import KRProgressHUD
import Firebase

class MyListViewController: UIViewController {
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var tableView: UITableView!
    //firebaseの用意
    let db = Firestore.firestore()
    //refreshcontrol
    weak var refreshControl:UIRefreshControl!
    //tableviewに設定する配列
    var colorArray:Array<Color> = []
    var count:Int?
    //tableviewcellの中身
    enum Tag:Int {
        case name = 1
        case image = 2
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //toolbarの色を黒にする
        toolbar.tintColor = UIColor.black
        //空のセルの区切り線をけす
        tableView.tableFooterView = UIView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //refreshcontrol作成
        let refreshcontrol = UIRefreshControl()
        refreshcontrol.addTarget(self, action: #selector(reloadColorData), for: .valueChanged)
        refreshcontrol.tintColor = UIColor.black
        self.refreshControl = refreshcontrol
        //tableviewのrefreshControlに設定する
        self.tableView.refreshControl = refreshControl
        
        reloadColorData()
    }
    
    //HomeViewControllerへ遷移
    @IBAction func tapBuckButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let next: UIViewController = storyboard.instantiateInitialViewController() as! UIViewController
        self.present(next, animated: true, completion: nil)
    }
    
    //cameraViewControllerへ遷移
    @IBAction func tapCameraView(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Camera", bundle: nil)
        let next: UIViewController = storyboard.instantiateInitialViewController() as! UIViewController
        self.present(next, animated: true, completion: nil)
    }
    
   
    
    
}


//tableViewの処理
extension MyListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.colorArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let name = cell.contentView.viewWithTag(Tag.name.rawValue) as! UILabel
        let imageView = cell.contentView.viewWithTag(Tag.image.rawValue) as! UIImageView
        
        let color = colorArray[indexPath.row]
        let path = color.path
        let rColorInt = Int(color.rgb[0])!
        let gColorInt = Int(color.rgb[1])!
        let bColorInt = Int(color.rgb[2])!
        let rColor = CGFloat(rColorInt)
        let gColor = CGFloat(gColorInt)
        let bColor = CGFloat(bColorInt)
        name.text = color.name + "色"
        print(path)
        imageView.backgroundColor = UIColor(red: rColor/255, green: gColor/255, blue: bColor/255, alpha: 1)
        if imageView.backgroundColor == UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1) {
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.borderWidth = 1
        }
        return cell
    }
    
    //tableviewcellタップ時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard: UIStoryboard = UIStoryboard(name: "MyListDetail", bundle: nil)
        let next = storyboard.instantiateViewController(withIdentifier: "MyListDetail") as! MyListDetailViewController
        next.color = self.colorArray[indexPath.row]
        self.present(next,animated: true,completion: nil)
    }
    
    //スワイプ削除設定
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            //ユーザー情報を得る
            let user = Auth.auth().currentUser
            let userId = user!.uid
            let color = self.colorArray[indexPath.row]
            let path = color.path
            
            db.collection("\(userId)").document(path).delete()
            
            self.colorArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        
        }
    }
    
    
}

//sectionが0の時画像を配置
extension MyListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        
        return UIImage(named: "nofavorite")
        
    }
    
}

//colordatamanager
extension MyListViewController: ColorDataManagerDelegate {
    func myListCountReadDidEnd(myListCount: Int) {
        self.count = myListCount
    }
    
    
    //firebase読み込み終了
    func FirebaseReadDidEnd(colorArray: [Color]) {
        //        //データソースをクリアする
        self.colorArray.removeAll()
        self.colorArray = colorArray
        //コレクションビューに変わったことを伝える
        self.tableView.reloadData()
        //refreshcontllor解除
        self.refreshControl.endRefreshing()
        KRProgressHUD.dismiss()
        
    }
    
    func FirebaseReadError(error: Error) {
        print("\(error)")
        //refreshcontroller解除
        self.refreshControl.endRefreshing()
        KRProgressHUD.dismiss()
    }
    
    
    //通信処理
    @objc func reloadColorData() {
        
        KRProgressHUD.set(style: .black)
        KRProgressHUD.set(activityIndicatorViewColors: [UIColor]([.white, .black]))
        KRProgressHUD.show()
        let colorDataManager = ColorDataManager()
        //delegateセット
        colorDataManager.delegate = self
        //データの取得
        colorDataManager.myListColorGet()
    }
    
    func reloadmyListCount() {
        let colorDataManager = ColorDataManager()
        colorDataManager.delegate = self
        colorDataManager.myListCountGet()
    }
    
}

