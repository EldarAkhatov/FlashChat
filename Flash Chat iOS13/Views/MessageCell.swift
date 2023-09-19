//
//  MessageCell.swift
//  Flash Chat
//
//  Created by Эльдар Ахатов on 19/09/23.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messaheBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
