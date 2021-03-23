//
//  FeedViewController.swift
//  InstaClone
//
//  Created by Taha Cakir on 21.03.2021.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var useremailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    
    var userImageArray = [String]()
    var documentIdArray = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        getDataFromFirestore()
    }
    
    func getDataFromFirestore() {
        let firestoreDatabase = Firestore.firestore()
//        ayarları değiştirmek istiyorum,tarihlerle sıkıntı yaşamamak için ama gerek kalmıyor.
//        let settings = firestoreDatabase.settings
//        firestoreDatabase.settings = settings
        
//        eklediklerimi çekmek için listener kullanıyorum.pathleri belirtebilirdik ama post altındaki hepsini almak istediğimden gerek duymuyorum.daha da filtrelenebilir.
//        firestoreDatabase.collection("Posts").document(<#T##documentPath: String##String#>).collection(<#T##collectionPath: String##String#>).addSnapshotListener { (snapshot, error) in
//        tarihe göre order ile sıraladım
        firestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print("Error")
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.useremailArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
//                    yeni yüklenenler görünsün diye sildim kalanları
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
//                        dokumanları ve kim tarafından post edildiyse özelleştirebilirim.
                        if let postedBy = document.get("postedBy") as? String {
                            self.useremailArray.append(postedBy)
                            
                        }
                        if let postComment = document.get("PostComment") as? String {
                            self.userCommentArray.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        if let imageURL = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageURL)
                        }
                    }
                    self.tableView.reloadData()
                    
                
            }
        }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return useremailArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        her birini tek tek feedte göstermek için yaptım aynı timeline gibi.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = useremailArray[indexPath.row]
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
//        görselleri url ile göstermek için SDWebImage kullandım.
        cell.imageView?.sd_setImage(with : URL(string: self.userImageArray[indexPath.row]))
        cell.documentIDLabel.text = documentIdArray[indexPath.row]
        
        
        return cell
    }
    
    
    
    
}
