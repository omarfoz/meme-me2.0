//
//  MemeDetailViewController.swift
//  MemeMe1.0
//
//  Created by Omar Yahya Alfawzan on 4/15/19.
//  Copyright © 2019 Omar Yahya Alfawzan. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    @IBOutlet weak var memeImageView: UIImageView!
    var meme:Meme?
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeImageView!.image = meme?.memedImage
    }

    @IBAction func edit(_ sender: Any) {
        
        let editMemeViewController = self.storyboard!.instantiateViewController(withIdentifier: "editMeme") as! EditMemeViewController
        editMemeViewController.flag = true
        editMemeViewController.editmeme = meme
        self.present(editMemeViewController, animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: false)
    
    }
}
