//
//  MeetingCell.swift
//  MeetingScheduler
//
//  Created by Aptence on 05/09/19.
//  Copyright © 2019 Verma. All rights reserved.
//

import UIKit

class MeetingCell: UICollectionViewCell {
    
    @IBOutlet weak var timelLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

