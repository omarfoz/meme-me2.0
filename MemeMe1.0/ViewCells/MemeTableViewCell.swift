//
//  TableViewCell.swift
//  MemeMe1.0
//
//  Created by Omar Yahya Alfawzan on 4/10/19.
//  Copyright © 2019 Omar Yahya Alfawzan. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memelabel: UILabel!
    
     func setCell(meme : Meme){
        self.memelabel.text = "\(meme.topText!)...\(meme.bottomText!)"
        self.memeImageView.image = meme.memedImage
    }
}
