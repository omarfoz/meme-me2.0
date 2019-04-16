//
//  MemeTableViewController.swift
//  MemeMe1.0
//
//  Created by Omar Yahya Alfawzan on 4/10/19.
//  Copyright © 2019 Omar Yahya Alfawzan. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
  
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let application = object as! AppDelegate
        return application.memes
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return memes.count
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell") as! MemeTableViewCell
           cell.setCell(meme: memes[indexPath.row])
            
        return cell
    }


   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let memeDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(memeDetailViewController, animated: true)
    }

    
    
}
