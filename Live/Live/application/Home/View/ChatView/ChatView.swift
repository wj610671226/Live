//
//  ChatView.swift
//  Live
//
//  Created by wangjie on 2017/7/1.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

class ChatView: UIView , LoadNibProtocol{
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendMessageBtn: UIButton!
    
    var sendMessage: ((_ message: String) -> Void)?
    
    private lazy var rightBtn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    private lazy var emoticonView: EmoticonView = EmoticonView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: 250))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initUI()
    }
    
    private func initUI() {
        rightBtn.setImage(UIImage(named: "chat_btn_emoji"), for: .normal)
        rightBtn.setImage(UIImage(named: "chat_btn_keyboard"), for: .selected)
        textField.rightView = rightBtn
        textField.rightViewMode = .always
//        rightBtn.addTarget(self, action: Selector("clickChangeKeyBoard:"), for: .touchDown)
        rightBtn.addTarget(self, action: #selector(ChatView.clickChangeKeyBoard(_:)), for: .touchDown)
        
        
        emoticonView.sendMessage = {(message: EmoticomModel) -> Void in
            guard "delete-n" != message.name else {
                self.textField.deleteBackward()
                return
            }
            
            guard let range = self.textField.selectedTextRange else { return }
            self.textField.replace(range, withText: message.name)
        }
    }
    
    func clickChangeKeyBoard(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let range = textField.selectedTextRange
        textField.resignFirstResponder()
        textField.inputView = sender.isSelected ? emoticonView : nil
        textField.becomeFirstResponder()
        textField.selectedTextRange = range
    }
    
    @IBAction func textFieldChange(_ sender: UITextField) {
        print(sender.text!.characters.count)
       sendMessageBtn.isEnabled = sender.text?.characters.count != 0
    }
    
    @IBAction func sendChatMessage(_ sender: UIButton) {
        let text = textField.text
        sendMessage?(text ?? "")
        textField.text = ""
        sender.isEnabled = false
    }
}
