//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Semafor on 23.09.2020.
//  Copyright © 2020 Semafor. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func chooseImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func uploadClicked(_ sender: UIButton) {
        //storage process**
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { (metaData, error) in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Unexpected error!")
                }else{
                    imageReference.downloadURL { (url, error) in
                        if error == nil{
                            let imageUrl = url?.absoluteString
                            //database process**
                            let fireStoreDatabase = Firestore.firestore()
                            var fireStoreReference: DocumentReference? = nil
                            
                            let fireStorePost = ["imageUrl":imageUrl!, "postedBy": Auth.auth().currentUser!.email, "postComment": self.commentText.text!, "date": FieldValue.serverTimestamp(), "likes":0] as [String : Any]
                            fireStoreReference = fireStoreDatabase.collection("Posts").addDocument(data: fireStorePost, completion: { (error) in
                                if error != nil{
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Unexpected error!")
                                }else{
                                    self.imageView.image = #imageLiteral(resourceName: "tappedImage")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                        }
                    }
                }
            }
        }
        
    }
    
    func makeAlert(titleInput:String, messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    

}
