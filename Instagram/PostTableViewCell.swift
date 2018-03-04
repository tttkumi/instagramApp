//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 前田 匠 on 2018/02/12.
//  Copyright © 2018年 前田 匠. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentEditButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setPostDate(postDate: PostDate){
        self.postImageView.image = postDate.image
        
        self.captionLabel.text = "\(postDate.name!) : \(postDate.caption!)"

        //self.commentLabel.text = postDate.comment
        
       // var commentText = ""
        // for commetns in postDate.comments {
         //    commentText += commentText + "\n"
       // }
          //commentLabel.text = commentText
       
        var comentall:String! = ""
        for comments in postDate.comments{
           let name = comments["name"]
           let comment = comments["comment"]
           comentall = comentall + "\(name!):\(comment!)\n"
      }
        self.commentLabel.text = comentall
            
        
       
        
        
        let likeNumber = postDate.likes.count
        likeLabel.text = "\(likeNumber)"
       
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        formatter.dateFormat = "yyyy-mm-dd HH:mm"
        
        let dateString:String = formatter.string(from: postDate.date! as Date)
        //self.dateLabel.text = dateString
        self.dateLabel.text = dateString
       
        if postDate.isLiked{
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: UIControlState.normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: UIControlState.normal)
            
            
        }
        
    }
    
}
