//
//  NoteTableViewCell.swift
//  note_avengers_iOS
//
//  Created by Vijay Kumar Sevakula on 2021-05-27.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var musicNoteIcon: UIImageView!
    @IBOutlet weak var noteImageView: UIImageView!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var noteBodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
