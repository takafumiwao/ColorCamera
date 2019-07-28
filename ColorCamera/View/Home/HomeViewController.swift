//
//  HomeViewController.swift
//  ColorCamera
//
//  Created by 岩男高史 on 2019/07/15.
//  Copyright © 2019 岩男高史. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Firebase
import KRProgressHUD

class HomeViewController: UIViewController {
    
    //refreshcontrol
    weak var refreshControl: UIRefreshControl!
    
    //collectonviewに入れるdata
    var colorArray:Array<Color> = []
    
    //viewのタグ番号
    enum Tag:Int {
        case image = 100
        case label = 101
    }

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 2.0, bottom: 2.0, right: 2.0)
    private let itemPerRow: CGFloat = 3
    //Firestoreのインスタンスを初期化
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        self.navigationController?.navigationBar.isTranslucent = false
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //refreshcontrolを作る
        let refreshControll = UIRefreshControl()
        //addtarget設定
        refreshControll.addTarget(self, action: #selector(reloadColorData), for: .valueChanged)
        refreshControll.tintColor = UIColor.black
        //collectionViewのrefreshControllに登録
        self.refreshControl = refreshControll
        
        self.collectionView.refreshControl = refreshControll
        
        
        reloadColorData()
    }
    
    
    
    
   
    

    
    //myListViewへ遷移
    @IBAction func myListButton(_ sender: Any) {
        //MyListViewControllerへ遷移
        let storyboard: UIStoryboard = UIStoryboard(name: "MyList", bundle: nil)
        let next: UIViewController = storyboard.instantiateInitialViewController() as! UIViewController
        self.present(next, animated: true, completion: nil)
    }
    
    //cameraViewへ遷移
    @IBAction func tapCameraButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Camera", bundle: nil)
        let next: UIViewController = storyboard.instantiateInitialViewController() as! UIViewController
        self.present(next, animated: true, completion: nil)
    }
    
}

//collectionViewの設定
extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //section数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(colorArray.count)
        return colorArray.count
    }
    
    //cellの設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath)
        
        //Configure the cell
        //storyboardで載せた画面部品をtagで取りだす
        let imageView = cell.contentView.viewWithTag(Tag.image.rawValue) as! UIImageView
        let label = cell.contentView.viewWithTag(Tag.label.rawValue) as! UILabel
        
        //表示用データの取得
        let color = self.colorArray[indexPath.row]
        let rColorInt = Int(color.rgb[0])!
        let gColorInt = Int(color.rgb[1])!
        let bColorInt = Int(color.rgb[2])!
        let rColor = CGFloat(rColorInt)
        let gColor = CGFloat(gColorInt)
        let bColor = CGFloat(bColorInt)
        
        label.text = color.name
        imageView.backgroundColor = UIColor(red: rColor/255, green: gColor/255, blue: bColor/255, alpha: 1)
        if imageView.backgroundColor == UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1) {
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.borderWidth = 1
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "HomeDetail", bundle: nil)
        let next = storyboard.instantiateViewController(withIdentifier: "HomeDetailViewController") as! HomeDetailViewController
        let indexPath = self.collectionView.indexPathsForSelectedItems?.first
        next.color = self.colorArray[indexPath!.row]
        
        self.present(next, animated: true, completion: nil)
    }
    
    
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        
//        let storyboard:UIStoryboard = UIStoryboard(name: "HomeDetail", bundle: nil)
//        let next:UIViewController = storyboard.instantiateInitialViewController() as! UIViewController
//        self.present(next, animated: true, completion: nil)
//    }
    
    //layoutの処理
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemPerRow
        return CGSize(width: widthPerItem, height: widthPerItem + 42)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    //セルの行間の設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
}

//sectionがない時の処理
extension HomeViewController: DZNEmptyDataSetDelegate,DZNEmptyDataSetSource {
    
    //画像をセット
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "nofavorite")
    }
}

//colordatamanager
extension HomeViewController: ColorDataManagerDelegate {
    func myListCountReadDidEnd(myListCount: Int) {
        print("test")
    }
    
    
    //firebase読み込み終了
    func FirebaseReadDidEnd(colorArray: [Color]) {
//        //データソースをクリアする
        self.colorArray.removeAll()
        self.colorArray = colorArray
        //コレクションビューに変わったことを伝える
        self.collectionView.reloadData()
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
        colorDataManager.colorGet()
    }
    
}
