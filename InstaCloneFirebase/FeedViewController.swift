//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by Semafor on 23.09.2020.
//  Copyright © 2020 Semafor. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var userLikeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        getDataFromFireStore()
        
    }
    
    func getDataFromFireStore(){
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true)
            .addSnapshotListener { (snapshot, error) in
            if error != nil{
                print("Error")
            }else{
                if snapshot?.isEmpty != true && snapshot != nil{
                    self.userImageArray.removeAll()
                    self.userLikeArray.removeAll()
                    self.userCommentArray.removeAll()
                    self.userEmailArray.removeAll()
                    self.documentIdArray.removeAll()
                    
                    for document in snapshot!.documents{
                        let documentId = document.documentID
                        self.documentIdArray.append(documentId)
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("postComment") as? String {
                            self.userCommentArray.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.userLikeArray.append(likes)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: userImageArray[indexPath.row]))
        cell.userCommentLabel.text = userCommentArray[indexPath.row]
        cell.likeLabel.text = String(userLikeArray[indexPath.row])
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        return cell
    }

}
