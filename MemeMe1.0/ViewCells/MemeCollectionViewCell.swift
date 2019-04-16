//
//  MemeCollectionViewCell.swift
//  MemeMe1.0
//
//  Created by Omar Yahya Alfawzan on 4/14/19.
//  Copyright © 2019 Omar Yahya Alfawzan. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var memeImageCollectionView: UIImageView!


    func setCell(meme : Meme){
        memeImageCollectionView.image = meme.memedImage
    }

}
