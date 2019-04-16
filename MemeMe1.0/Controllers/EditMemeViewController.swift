//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Omar Yahya Alfawzan on 4/2/19.
//  Copyright © 2019 Omar Yahya Alfawzan. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate{

    
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var generatedMemeImage: UIImage!
    var nilImage: UIImage!
    var editmeme:Meme?
    var flag = false
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let application = object as! AppDelegate
        return application.memes
    }
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.5
    ]
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !flag {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        memeImageView.image = nilImage
        shareButton.isEnabled = false
        prepareTextField(textField: topTextField, defaultText: "TOP")
        prepareTextField(textField: bottomTextField, defaultText: "BOTTOM")
        }else {
            setEditMeme(meme: editmeme!)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    
        subscribeToKeyboardNotifications()
        
        if memeImageView.image == nilImage {
            shareButton.isEnabled = false
        }else {
            shareButton.isEnabled = true
        }
    
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func subscribeToKeyboardNotifications() {
        
      
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= getKeyboardHeight(notification as Notification)
            }
        
    }

    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    func prepareTextField(textField: UITextField, defaultText: String) {
        textField.text = defaultText
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
        
    }
    func setEditMeme(meme:Meme){
       
        prepareTextField(textField: topTextField, defaultText: meme.topText!)
        prepareTextField(textField: bottomTextField, defaultText: meme.bottomText!)
        memeImageView!.image = meme.originalImage
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
      {
        
        
        if let image = info[.originalImage] as? UIImage  {
           memeImageView.image = image
        }
      
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func clickShare(_ sender: Any) {
        
        generatedMemeImage = generateMemedImage()
        let shareActionVC: UIActivityViewController = UIActivityViewController(activityItems: [generatedMemeImage, "Check my meme 😂😂😂😂😂"], applicationActivities: nil)
       
        shareActionVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
              debugPrint("not saved")
                return
            }
           self.save()
           self.flag = false
           self.dismiss(animated: true, completion: nil)
        }
        self.present(shareActionVC, animated: true, completion: nil)
    }
    
    
    func pickImage(sourceType: UIImagePickerController.SourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func clickCancel(_ sender: Any) {
        memeImageView.image = nilImage
        shareButton.isEnabled = false
        prepareTextField(textField: topTextField, defaultText: "TOP")
        prepareTextField(textField: bottomTextField, defaultText: "BOTTOM")
        flag = false
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cameraClick(_ sender: Any) {
        pickImage(sourceType: .camera)
    }
    
    
    @IBAction func albumClick(_ sender: Any) {
        pickImage(sourceType: .photoLibrary)
    }
    
    
    @IBAction func topTextFieldBeginEdit(_ sender: Any) {
        if topTextField.text == "TOP" {
           topTextField.text = ""
        }
         unsubscribeFromKeyboardNotifications()
    }
    
    
    @IBAction func topTexfieldEnd(_ sender: Any) {
        textFieldShouldReturn(topTextField)
        subscribeToKeyboardNotifications()
    }
    
    
    @IBAction func bottomFieldBeginEdit(_ sender: Any) {
        if bottomTextField.text == "BOTTOM" {
         bottomTextField.text = ""
        }
    }
    
    
    @IBAction func BottomTextFieldEnd(_ sender: Any) {
        
        textFieldShouldReturn(bottomTextField)

    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    func save() {
        // Create the meme
        var cropImage = cropToBounds(image: generatedMemeImage, width: 100, height: 88)
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, memedImage: cropImage)
       
        
        if flag {
            
            for index in 0..<memes.count {
                if memes[index].memedImage == editmeme?.memedImage {
                   (UIApplication.shared.delegate as! AppDelegate).memes[index] = meme
                    
                    let memeDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
                    memeDetailViewController.meme = meme
                   flag = false
                  

                }
            }
        }else {
             (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        }
        
   }
    
    
    func generateMemedImage() -> UIImage {
        
        topToolBar.isHidden = true
        bottomToolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        topToolBar.isHidden = false
        bottomToolBar.isHidden = false
       
        return memedImage
    }

    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
}
