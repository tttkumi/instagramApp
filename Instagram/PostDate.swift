//
//  PostDate.swift
//  Instagram
//
//  Created by 前田 匠 on 2018/02/12.
//  Copyright © 2018年 前田 匠. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class PostDate: NSObject {
    
    var id: String?
    var image: UIImage?
    var imageString: String?
    var name: String?
    var caption: String?
    var date: NSDate?
    var likes: [String] = []
    var isLiked: Bool = false
    var comment: String?
    //var comments: [String] = []
    var comments: [[String:String]] = []
    
    
    init(snapshot: DataSnapshot,myId: String){
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String: AnyObject]
        
        imageString = valueDictionary["image"] as? String
        
        image = UIImage(data: NSData(base64Encoded: imageString!, options: .ignoreUnknownCharacters)! as Data)
        
        
        self.name = valueDictionary["name"] as? String
        self.caption = valueDictionary["caption"]as? String
        let time = valueDictionary["time"]as? String
        self.date = NSDate(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        self.comment = valueDictionary["comment"]as? String
        
        // if let comments = valueDictionary["comments"]as? [String]{
        //self.comments = comments
        // }
        
        if let comments = valueDictionary["comments"]as? [[String:String]] {
            self.comments = comments
        }
        
        if let likes = valueDictionary["likes"]as? [String] {
            self.likes = likes
        }
        
        
        
        for likeId in self.likes {
            if likeId == myId {
                self.isLiked = true
                break
                
            }
        }
    }
}
