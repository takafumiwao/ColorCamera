//
//  ImageViewController.swift
//  ColorCamera
//
//  Created by 岩男高史 on 2019/07/28.
//  Copyright © 2019 岩男高史. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var tapPoint = CGPoint(x: 0, y: 0)
    @IBAction func oneTapImage(_ sender: Any) {
        guard cameraImage.image != nil else {return}
        
        tapPoint = (sender as AnyObject).location(in: cameraImage)
        
        let cgImage = cameraImage.image?.cgImage!
        let pixelData = cgImage?.dataProvider!.data
        let data: UnsafePointer = CFDataGetBytePtr(pixelData)
        let bytesPerPixel = (cgImage?.bitsPerPixel)! / 8
        let bytesPerRow = (cgImage?.bytesPerRow)!
        
        let pixelAd: Int = Int(tapPoint.y) * bytesPerRow + Int(tapPoint.x) * bytesPerPixel
        let r = CGFloat(data[pixelAd])
        let g = CGFloat(data[pixelAd + 1])
        let b = CGFloat(data[pixelAd + 2])
        let a = CGFloat(Int( CGFloat(data[pixelAd+3])/CGFloat(255.0)*100)) / 100
        let intr = Int(r)
        let intg = Int(g)
        let intb = Int(b)
        let rtext = String(intr)
        let gtext = String(intg)
        let btext = String(intb)
        print(rtext)
        let storyboard:UIStoryboard = UIStoryboard(name: "ColorDetail", bundle: nil)
        let next = storyboard.instantiateViewController(withIdentifier: "ColorDetailViewController") as! ColorDetailViewController
        next.color = UIColor(red: r, green: g, blue: b, alpha: a)
        next.r = rtext
        next.g = gtext
        next.b = btext
        self.present(next, animated: true, completion: nil)
    }
    
    var cameraImage:UIImageView!
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        
        print("\(image!)")
        cameraImage = UIImageView(image: image!)
        cameraImage.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    
        scrollView.addSubview(cameraImage!)
        
        let doubleTap = UITapGestureRecognizer(target:self,action:#selector(ImageViewController.doubleTap(gesture:)))
        
        doubleTap.numberOfTapsRequired = 2
        
        cameraImage.isUserInteractionEnabled = true
        
        cameraImage.addGestureRecognizer(doubleTap)
        
    }
    
    
    
    @objc func doubleTap(gesture:UITapGestureRecognizer) -> Void {
        
        if(self.scrollView.zoomScale < 3){
            
            let newScale:CGFloat = self.scrollView.zoomScale*3
            
            let zoomRect:CGRect = self.zoomForScale(scale:newScale, center:gesture.location(in:gesture.view))
            
            self.scrollView.zoom(to:zoomRect, animated: true)
            
        } else {
            
            self.scrollView.setZoomScale(1.0, animated: true)
            
        }
        
    }
    
    func zoomForScale(scale:CGFloat, center: CGPoint) -> CGRect{
        
        var zoomRect: CGRect = CGRect()
        
        zoomRect.size.height = self.scrollView.frame.size.height / scale
        
        zoomRect.size.width = self.scrollView.frame.size.width  / scale
        
        
        
        zoomRect.origin.x = center.x - zoomRect.size.width / 2.0
        
        zoomRect.origin.y = center.y - zoomRect.size.height / 2.0
        
        
        
        return zoomRect
        
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        print("end zoom")
        
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        
        print("start zoom")
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.cameraImage
        
    }
    
    
}
