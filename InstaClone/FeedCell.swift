//
//  FeedCell.swift
//  InstaClone
//
//  Created by Taha Cakir on 22.03.2021.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {

    
    @IBOutlet weak var documentIDLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var zeroLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
//    @IBOutlet weak var useremailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likebutton(_ sender: Any) {
        let firestoreDatabase = Firestore.firestore()
        if let likeCount = Int(likeLabel.text!) {
            let likeStore = ["likes" : likeCount + 1] as? [String : Any]
//            sadece like ları güncellemek için merge ile set ettim sadece likeları ve ileri doğru gidecek her tıklanmada.Kim kimi takip ettiğini görmek istersem collection açarım like için ve onları check edebilirim.
            firestoreDatabase.collection("Posts").document(documentIDLabel.text!).setData(likeStore, merge: true)
            
        }
        
        
    }
    
    
    
}
