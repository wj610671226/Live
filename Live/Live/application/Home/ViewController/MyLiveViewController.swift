//
//  MyLiveViewController.swift
//  Live
//
//  Created by wangjie on 2017/7/17.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit
import AVFoundation
import LFLiveKit

class MyLiveViewController: UIViewController {

    @IBOutlet weak var stackTop: NSLayoutConstraint!
    
    fileprivate lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.default()
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.low2, outputImageOrientation: .portrait)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        session?.delegate = self
        session?.preView = self.view
        return session!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if IS_IPHONE_X { stackTop.constant = 44 }
    }
    
    @IBAction func startLive(_ sender: UIButton) {
        // 判断摄像头是否可以用
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        guard status ==  AVAuthorizationStatus.restricted || status == AVAuthorizationStatus.denied else {
            let alert = UIAlertController.init(title: "温馨提示", message: "请使用真机或者检查权限", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let stream = LFLiveStreamInfo()
        stream.url = "your url";
        session.startLive(stream)
        session.running = true
    }
    
    @IBAction func stopLive(_ sender: UIButton) {
        if session.running { session.stopLive() }
    }
    
    @IBAction func clickBack(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}


extension MyLiveViewController: LFLiveSessionDelegate {
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print("debugInfo = \(String(describing: debugInfo?.streamId))")
    }
    
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("error = \(errorCode.rawValue)")
    }
    
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        print("state = \(state.hashValue)")
    }
}
