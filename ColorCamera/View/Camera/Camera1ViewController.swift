//
//  Camera1ViewController.swift
//  ColorCamera
//
//  Created by 岩男高史 on 2019/07/30.
//  Copyright © 2019 岩男高史. All rights reserved.
//

import UIKit
import AVFoundation

class Camera1ViewController: UIViewController {
    
    //デバイスからの入力と出力を管理するオブジェクトの作成
    var captureSession = AVCaptureSession()
    //カメラデバイスそのものを管理するオブジェクトの作成
    //メインカメラの管理オブジェクトの作成
    var mainCamera: AVCaptureDevice?
    //インンカメの管理オブジェクトの作成
    var innerCamera: AVCaptureDevice?
    //現在使用しているカメラデバイスの管理オブジェクトの作成
    var currentDevice: AVCaptureDevice?
    //キャプチャーの出力データを受け付けるオブジェクト
    var photoOutput: AVCapturePhotoOutput?
    //プレビュー表示用のレイヤ
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        captureSession.startRunning()
        
    }
    
    //カメラの画質の設定
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    //デバイスの設定
    func setupDevice() {
        //カメラデバイスのプロパティ設定
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        //プロパティの条件を満たしたカメラデバイスの取得
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                mainCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                innerCamera = device
            }
        }
        
        //起動時のカメラを設定
        currentDevice = mainCamera
    }
    
    //入出力データの設定
    func setupInputOutput() {
        do {
            //指定したデバイスを使用するために入力を初期化
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            //指定した入力をセッションに追加
            captureSession.addInput(captureDeviceInput)
            //出力データを受け取るオブジェクトの作成
            photoOutput = AVCapturePhotoOutput()
            //出力ファイルのフォーマットの指定
            photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    //カメラのプレビューを表示するレイヤの設定
    func setupPreviewLayer() {
        //指定したAVCaptureSessionでプレビューレイヤを初期化
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //プレビューレイヤがカメラのキャプチャーを縦横比を維持した状態で、表示するように設定
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        //プレビューレイヤの表示の向きを設定s
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        
        self.cameraPreviewLayer?.frame = view.frame
        self.view.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
    }

}
