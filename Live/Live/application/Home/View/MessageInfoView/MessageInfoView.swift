//
//  MessageInfoView.swift
//  Live
//
//  Created by wangjie on 2017/7/5.
//  Copyright © 2017年 wangjie. All rights reserved.
//

import UIKit

private let cellID: String = "MessageTableViewCell"

class MessageInfoView: UIView, LoadNibProtocol {

    @IBOutlet weak var infoTableView: UITableView!
    fileprivate var data: [NSAttributedString] = Array()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        infoTableView.estimatedRowHeight = 40
        infoTableView.rowHeight = UITableViewAutomaticDimension
        
        infoTableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
    }
}

extension MessageInfoView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? MessageTableViewCell
        
        cell?.infoLabel.attributedText = data[indexPath.item]
        
        return cell!
    }
}


extension MessageInfoView {
    func insertMessage(_ message: NSAttributedString) {
        data.append(message)
        infoTableView.reloadData()
        let indexPath = IndexPath(item: data.count - 1, section: 0)
        infoTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}
