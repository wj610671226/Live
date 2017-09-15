//
//  LiveViewController.swift
//  Live
//
//  Created by wangjie on 2017/6/27.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit
import Kingfisher
import IJKMediaFramework

class LiveViewController: UIViewController, EmitterProtocol {

    fileprivate lazy var chatView: ChatView = ChatView.loadNibNamed("ChatView")
    fileprivate lazy var giftView: GiftView = GiftView.loadNibNamed("GiftView")
    fileprivate lazy var infoView: MessageInfoView = MessageInfoView.loadNibNamed("MessageInfoView")
    fileprivate lazy var giftContentView = GiftContentView(frame: CGRect(x: 0, y: 100, width: 260, height: 80))
    
    fileprivate lazy var socket: Socket = Socket("192.168.2.10", 8989)
    fileprivate lazy var timer: Timer = Timer(fireAt: Date(), interval: 10, target: self, selector: #selector(LiveViewController.sendHeartbeat), userInfo: nil, repeats: true)
    
    var model: WaterFallModel?
    fileprivate lazy var liveViewModel: LiveViewModel = LiveViewModel()
    fileprivate var ijkPlayer : IJKFFMoviePlayerController?
    fileprivate var infoY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        initUI()
        initSocket()
        initLiveView()
        
    }

    @IBAction func clickRightTopBtn(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("sss")
        default:
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func clickBottomBtn(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            showChatView()
        case 1:
            print("第3按钮")
        case 2:
            showGiftView()
        case 3:
            print("第4按钮")
        case 4:
            createEmitterLayer(sender)
        default:
            print("")
        }
    }
    
    private func initLiveView() {
        guard let roomid = model?.roomid, let uid = model?.uid else { return }
        liveViewModel.loadLiveRoomData(roomid, uid) { liveUrl in
            self.displayLiveView(liveUrl)
        }
    }
    
    fileprivate func displayLiveView(_ liveURLString : String?) {
        
        // 1.获取直播的地址
        guard let liveURLString = liveURLString else {
            return
        }
        
        // 2.使用IJKPlayer播放视频
        let options = IJKFFOptions.byDefault()
        options?.setOptionIntValue(1, forKey: "videotoolbox", of: kIJKFFOptionCategoryPlayer)
        ijkPlayer = IJKFFMoviePlayerController(contentURLString: liveURLString, with: options)
        
        // 3.设置frame以及添加到其他View中
        if model?.push == 1 {
            ijkPlayer?.view.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: KScreenWidth, height: KScreenWidth * 3 / 4))
            ijkPlayer?.view.center = CGPoint(x: KScreenWidth / 2, y: KScreenHeight / 2)
        } else {
            ijkPlayer?.view.frame = view.bounds
        }
        view.insertSubview(ijkPlayer!.view, at: 0)
        
        // 4.开始播放
        ijkPlayer?.prepareToPlay()
    }
    
    
    private func initSocket() {
        // 连接socket
        
        guard socket.connect(5) else {
            print("socket连接失败")
            return
        }

        socket.delegate = self
        RunLoop.main.add(timer, forMode: .commonModes)
        socket.joinRoom()
    }
    
    private func createEmitterLayer(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let point = CGPoint(x: sender.center.x, y: KScreenHeight - sender.center.y)
        var images: [String] = Array()
        for index in 0..<10 {
            images.append("good\(index)_30x30")
        }
        sender.isSelected ? createEmitterAnimation(point, images) : stopEmitterAnimation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        chatView.textField.resignFirstResponder()
        UIView.animate(withDuration: 0.25) {
            self.giftView.frame.origin.y = self.view.bounds.height
            
            self.infoView.frame.origin.y = self.infoY
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        socket.levelRoom()
        ijkPlayer?.shutdown()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("释放")
    }
}


// MARK: - ChatView
extension LiveViewController {
    fileprivate func initUI() {
        
        // messageInfoView
        let height: CGFloat = KScreenHeight / 2.0 - KScreenWidth * 3.0 / 4.0 / 2.0 - 49.0
        let y: CGFloat = KScreenHeight - height - 49.0
        infoY = y
        infoView.frame = CGRect(x: 0, y: y, width: KScreenWidth, height: height)
        view.addSubview(infoView)
        
        
        // chatView
        chatView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 40)
        chatView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        chatView.sendMessage = { [weak self] message in
            self?.socket.sendChatMessage(message)
        }
        view.addSubview(chatView)
        
        
        // giftView
        view.addSubview(giftView)
        giftView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 250)
        giftView.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
        giftView.sendGiftHandler = { [weak self] giftmodel in
            self?.socket.sendGiftMessage(giftmodel.subject, giftmodel.img)
        }
        
        // giftContentView
        view.addSubview(giftContentView)
        giftContentView.backgroundColor = UIColor.clear
        
    }
    
    fileprivate func showChatView() {
        chatView.textField.becomeFirstResponder()
    }
    
    
    fileprivate func showGiftView() {
        let y: CGFloat = view.bounds.height - giftView.bounds.height
        UIView.animate(withDuration: 0.25) { 
            self.giftView.frame.origin.y = y
            
//            self.infoView.frame.origin.y -= self.giftView.bounds.height
        }
    }
    
    @objc fileprivate func keyboardFrameChange(_ notification: Notification) {
        
        let timeinterval: TimeInterval = notification.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! TimeInterval
        let endframe = notification.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue
        let endy: CGFloat = endframe.cgRectValue.origin.y
        
        let chatViewY = (endy == view.bounds.height) ? endy + chatView.frame.size.height : endy - chatView.frame.size.height
        
        let infoViewY: CGFloat = (endy == view.bounds.height) ? view.bounds.height - infoView.bounds.height - 44 : infoView.frame.origin.y - endframe.cgRectValue.height
        UIView.animate(withDuration: timeinterval) {
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: 7)!)
            self.chatView.frame.origin.y = chatViewY
            
            self.infoView.frame.origin.y = infoViewY
        }
    }
    
    
}


// MARK: - socket
extension LiveViewController: SocketDelegate, AttributedProtocol {
    // 发送心跳包
    @objc func sendHeartbeat() {
        socket.sendHeartbeat()
    }
    
    func joinRoom(userInfo: UserInfo) {
        guard let name = userInfo.name else { return }
        let attr = createRoomAttributeString(name, true)
        infoView.insertMessage(attr)
    }
    
    func leaveRoom(userInfo: UserInfo) {
        guard let name = userInfo.name else { return }
        let attr = createRoomAttributeString(name, false)
        infoView.insertMessage(attr)
    }
    
    func sendChatMessage(chatMessage: ChatMessage) {
        guard let text = chatMessage.name else { return }
        let attr = createChatAttributeString(chatMessage.userInfo.name!, text)
        infoView.insertMessage(attr)
    }
    
    func sendgiftMessage(giftMessage: GiftMessage) {
        // 显示到信息窗口
        DispatchQueue.global().async {
            
            guard let giftname = giftMessage.name else { return }
            
            let pattern = "\\(.*?\\)"
            let regex = try! NSRegularExpression(pattern: pattern, options: [])
            let result = regex.matches(in: giftMessage.name, options: [], range: NSRange(location: 0, length: giftMessage.name.characters.count))
            
            var giftName: String = giftname
            if result.count > 0 {
                giftName = (giftMessage.name as NSString).replacingCharacters(in: result.first!.range, with: "")
            }
            
            // 显示到礼物窗口
            let model = GiftContentModel()
            model.name = giftMessage.userInfo.name
            model.giftName = giftName
            model.giftUrl = giftMessage.imgUrl
            
            let attr = self.createGiftAttributeString(giftMessage.userInfo.name!, giftName, giftMessage.imgUrl)
            
            DispatchQueue.main.async {
                self.giftContentView.sendGift(model: model)
//                self.infoView.insertMessage(attr)
            }
        }
        
    }
}

