//
//  EditPhoto.swift
//  Mobile UCC
//
//  Created by LabSE Siskom on 11/23/17.
//  Copyright © 2017 LabSE Siskom. All rights reserved.
//

import UIKit
import PKHUD
import Photos

class EditPhoto: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet var profPic: UIImageView!
    
    let imagePicker = UIImagePickerController()
    let url = "http://api.career.undip.ac.id/v1/jobseekers/edit_cv_part/edit_photo"
    
    var passedData : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Edit Photo"
        
        //create a new button
        let button = UIButton.init(type: .custom)
        //set image for button
        button.setImage(UIImage(named: "edit"),for: UIControlState())
        //add function for button
        button.addTarget(self, action: #selector(editButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
        
        let urlPicRaw = passedData
        let urlPic = URL (string: urlPicRaw)
        /*let networkService = NetworkService(url: urlPic!)
        networkService.downloadImage({ (imageData) in
            let image = UIImage(data: imageData as Data)
            DispatchQueue.main.async(execute: {
                self.profPic.image = image
            })
        })*/
        
        parseImagetoView(urlPic!)
        
        imagePicker.delegate = self
    }
    
    func parseImagetoView(_ urlPic: URL) {
        let networkService = NetworkService(url: urlPic)
        networkService.downloadImage({ (imageData) in
            let image = UIImage(data: imageData as Data)
            DispatchQueue.main.async(execute: {
                self.profPic.image = image
            })
        })
    }

    func editButtonAction(sender: UIBarButtonItem){
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                //alert.popoverPresentationController?.sourceView = sender
                //alert.popoverPresentationController?.sourceRect = sender.bounds
                alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
    if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    /*func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
            let image_data = info[UIImagePickerControllerOriginalImage] as? UIImage
            let imageData:Data = UIImagePNGRepresentation(image_data!)!
            let imageStr = imageData.base64EncodedString()
            let imageUrl = info[UIImagePickerControllerPHAsset] as? NSURL
            let imageName: String = (imageUrl?.lastPathComponent)!
            //let imageNameStr = "\(imageName ?? "nil")"

            let defaults = UserDefaults.standard
            let url = URL(string: "http://api.career.undip.ac.id/v1/jobseekers/edit_cv_part/edit_photo")
            
            let preference_block = defaults.object(forKey: "session")
            var preferences = preference_block as! [Any]
            
            let username = (preferences[0] as! String)
            let token = (preferences[1] as! String)
            
            let loginString = String(format: "%@:%@", username, token)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            let session = URLSession.shared
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            request.setValue("fjJMPaeBaEWpMFnybMwbT5fSSLt8kUU", forHTTPHeaderField: "X-UndipCC-API-Key")
            
            let paramToSend = "avatar=" + imageStr + "&filename=" + imageName
            
            request.httpBody = paramToSend.data(using: String.Encoding.utf8)
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) in
                
                guard let _:Data = data else
                {
                    return
                }
                
                let json:Any?
                
                do
                {
                    json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                }
                catch
                {
                    return
                }
                
                
                guard let server_response = json as? [String:Any] else
                {
                    return
                }
                
                
                if let data_block = server_response["status"] as? String
                {
                    
                    
                    if (data_block=="ok") {
                        do {
                            let data_dictionary = server_response["data"] as? NSDictionary
                            let avatarURL = data_dictionary?["avatar"] as? String
                            print(avatarURL!)
                            let urlPic2 = URL (string: avatarURL!)
                            let networkService = NetworkService(url: urlPic2!)
                            networkService.downloadImage({ (imageData) in
                                let image = UIImage(data: imageData as Data)
                                DispatchQueue.main.async(execute: {
                                    self.profPic.image = image
                                    
                                })
                            })
                        }
                    
                    }
                    else if (data_block=="error"){
                        let message = server_response["message"] as? String
                        self.createAlert(title: "WARNING!", message: message!)
                    }
                }
                
            })
            
            task.resume()
        
        self.dismiss(animated: true, completion: nil)
    
    }
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        /*let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 200);
         
         let width : NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300);
         
         alert.view.addConstraint(height);
         
         alert.view.addConstraint(width);*/
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }*/
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        HUD.show(.progress)
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            // imageViewPic.contentMode = .scaleToFill
            let imageData:Data = UIImagePNGRepresentation(pickedImage)!
            let imageStr = imageData.base64EncodedString()
            let imageUrl = info[UIImagePickerControllerImageURL] as? URL
            //let result = PHAssetResource.assetResources(for: imageUrl!)
            //let asset = result.firstObject
            //let imageName = "\(result.first!.originalFilename)"
            //print(imageName)
            /*if let imageURL = info[UIImagePickerControllerPHAsset] as? URL {
                let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                let asset = result.firstObject
                print(asset?.value(forKey: "filename"))
                
            }*/
            let imageName = imageUrl?.lastPathComponent
            print(imageName ?? "nil")
            let paramToSend = "avatar=" + imageStr + "&filename=" + imageName!
            
            NetworkService.parseJSONFromURL(self.url, "POST", parameter: paramToSend){ (server_response) in
                if let status = server_response["status"] as? String {
                    if (status == "ok") {
                        let data_dictionary = server_response["data"] as? NSDictionary
                        let avatarURL = data_dictionary?["avatar"] as? String
                        print(avatarURL!)
                        let urlPicNew = URL (string: avatarURL!)
                        
                        self.parseImagetoView(urlPicNew!)
                        
                        DispatchQueue.main.async {
                            HUD.hide()
                        }
                    } else {
                        let message = server_response["message"] as? String
                        
                        DispatchQueue.main.async {
                            HUD.hide()
                            Alert.showMessage(title: "WARNING!", msg: message!)
                        }
                    }
                }
            }
            
        }
        picker.dismiss(animated: true, completion: nil)
    }

}
