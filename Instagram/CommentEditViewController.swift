//
//  CommentEditViewController.swift
//  Instagram
//
//  Created by 前田 匠 on 2018/02/15.
//  Copyright © 2018年 前田 匠. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD


class CommentEditViewController: UIViewController {
    
    var postData:PostDate!
    
    
    @IBOutlet weak var textComment: UITextView!
    
    @IBAction func finishComment(_ sender: Any) {
        
        let name = Auth.auth().currentUser?.displayName
        
        let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
        
        
        
        postData.comments.append(["name": name!, "comment": textComment.text!])
        postRef.updateChildValues(["comments":postData.comments])
        
        //let comments = ["name": name!, "comment": textComment.text!]
        //print("comments: \(comments)")
        //postRef.updateChildValues(comments)
        
        
        
        //HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "投稿しました")
        
        //全てのモーダルを閉じる
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        
        
        
        
    }
    @IBAction func commentCancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
