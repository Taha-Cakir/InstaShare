//
//  UploadViewController.swift
//  InstaClone
//
//  Created by Taha Cakir on 21.03.2021.
//

import UIKit
import Firebase

class UploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)

        // Do any additional setup after loading the view.
    }
    @objc func chooseImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
//    seçtikten sonra ne olacak? didfinish..
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
//        işlem sonunda sonlandırdım,info plist düzeltmesi de yapıldı.
        self.dismiss(animated: true, completion: nil)
    }
    func makeAlert(titleInp : String , messageInp : String) {
        let alert = UIAlertController(title: titleInp, message: messageInp, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func uploadButton(_ sender: Any) {
        let storage = Storage.storage()
        let sReference = storage.reference()
//        folder oluşturdum media için,
        let medFolder = sReference.child("media")
        
//        data olarak kaydediyorum
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
//            id vermezsem aynı fotograf dönüp duracak id ile kaydettim.jpg olarak tabiki yoksa dms olarak app te hata cıkarabilir.string içine koyup jpeg ekledim.
            let imageReference = medFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(titleInp: "Error", messageInp: error?.localizedDescription ?? "Error")
                }else {
//                    bana yüklenen image ın url si gerekiyor hata yoksa onu çekecegim.
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
//                            url mi bir string olarak çevirmek istiyorum
                            let imageUrl = url?.absoluteString
                            
//                            print(imageUrl) terminalde yazdırıp url ile check edilebilir.
//                            ****Database *****
                            let firestoreDatabase = Firestore.firestore()
                            var FirestoreReference : DocumentReference? = nil
//                            firestorepostta oluşturacagımız ve saklayacagımız dataları gösterdim ki database de saklayabilelim.date i güncel olarak servertimestamp ile aldım.
                            let firestorePost = ["imageUrl" : imageUrl!,"postedBy" :Auth.auth().currentUser!.email!,"postComment" : self.commentText.text!,"date" : FieldValue.serverTimestamp(),"likes" : 0] as [String : Any]
                            FirestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    self.makeAlert(titleInp: "Error", messageInp: error?.localizedDescription ?? "Error")
                                }else {
//                                    0 derken feed e götürecek 1 dersen upload a selceted ile bu işlemi yapıyorsun
                                    self.imageView.image = UIImage(named: "select")
                                    self.commentText.text = ""
//                                    basa götürmeden 0 lamamız gerekiyordu onun için yaptım üstteki işlemleri,tekrar gidildiğinde boş olsun diye
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                            
                            
                            
                        }
                    }
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
