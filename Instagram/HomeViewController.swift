//
//  HomeViewController.swift
//  Instagram
//
//  Created by 前田 匠 on 2018/02/02.
//  Copyright © 2018年 前田 匠. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    //class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var postArray : [PostDate] = []
    
    //DatabaseのobserveEventの登録状態を表す
    var observing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //テーブルセルのタップを無効にする
        tableView.allowsSelection = false
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
      
        if Auth.auth().currentUser != nil {
            if self.observing == false {
                // 要素が追加されたらpostArrayに追加してTableViewを再表示する
                let postsRef = Database.database().reference().child(Const.PostPath)
                postsRef.observe(.childAdded, with: { snapshot in
                    print("DEBUG_PRINT: .childAddedイベントが発生しました。")
                    
                    
                    //PostDateクラスを生成して受け取ったデータを設定する
                    if let uid = Auth.auth().currentUser?.uid {
                        let postDate = PostDate(snapshot: snapshot, myId: uid)
                        self.postArray.insert(postDate, at: 0)
                        
                        //TableViewを再表示する
                        self.tableView.reloadData()
                    }
                    
                })
                
                //要素が変更されたら該当データをpostArayから一度削除した後に新しいデータを追加したTableViewを再表示する
                // postsRef.observe(.childChange, with: { snapshot in
                postsRef.observe(.childChanged, with: { snapshot in
                    print("DEBUG_PRINT: .childChangeイベントが発生しました。")
                    
                    if let uid = Auth.auth().currentUser?.uid {
                        //postdataクラスを生成して受け取ったデータを設定する
                        let postDate = PostDate(snapshot: snapshot, myId: uid)
                        
                        //保持している配列からidが同じものを探す
                        var index: Int = 0
                        for post in self.postArray {
                            if post.id == postDate.id {
                                index = self.postArray.index(of: post)!
                                break
                            }
                        }
                        //差し替えるため一度削除する
                        self.postArray.remove(at: index)
                        
                        //削除したとろろに更新済みのデータを追加する
                        self.postArray.insert(postDate, at: index)
                        
                        //TableViewの現在表示されているセルを更新する
                        // self.tableView.reloadDate()
                        self.tableView.reloadData()
                    }
                })
                //DatabaseのobserveEventが上記コードより登録されたため
                //trueとする
                observing = true
                
            }
            
            
        } else {
            
            if observing == true {
                //ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する
                //テーブルをクリアする
                postArray = []
                tableView.reloadData()
                //オブザーバーを削除する
                Database.database().reference().removeAllObservers()
                
                //DatabaseのobserveEventが上記コードにより解除されたため
                //falseとする
                observing = false
                
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int{
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //セルを取得してデータを設定する。
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! PostTableViewCell
        cell.setPostDate(postDate: postArray[indexPath.row])
        
        //セル内のボタンのアクションをソースコードで設定する
        cell.likeButton.addTarget(self, action:#selector(handleButton(sender:event:)), for:  UIControlEvents.touchUpInside)
        
        cell.commentEditButton.addTarget(self, action:#selector(handleCommentButton(sender:event:)), for: UIControlEvents.touchUpInside)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //Auto lyout を使ってセルの高さを動的に変更るす。
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //セルをタップされたら何もせずに選択状況を解除する
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        
    }
    
    //セル内のボタンがタプされた時に呼ばれるメソッド
    func handleButton(sender: UIButton, event:UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")
       
        
        //タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        //配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        //Firebaseに保存するデータの準備
        if let uid = Auth.auth().currentUser?.uid{
            if postData.isLiked {
                //すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1
                for likeId in postData.likes {
                    if likeId == uid {
                        //削除するためにインデックスを保持しておく
                        index = postData.likes.index(of: likeId)!
                        break
                    }
                }
                postData.likes.remove(at: index)
            } else {
                postData.likes.append(uid)
            }
            //増えたlikesをFirebaseに保持する
            let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
            
            let likes = ["likes": postData.likes]
            postRef.updateChildValues(likes)
            
            
        }
        
    }
   
    func handleCommentButton(sender: UIButton, event:UIEvent) {
         print("DEBUG_PRINT: commentボタンがタップされました。")
        
        //タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
   
        //配列からタップされたインデックスのデータを取り出す
        let CommentEditViewController = self.storyboard?.instantiateViewController(withIdentifier: "Comment") as!CommentEditViewController
        
        CommentEditViewController.postData = postArray[indexPath!.row]
        
        self.present(CommentEditViewController, animated: true, completion: nil)
        
        
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
