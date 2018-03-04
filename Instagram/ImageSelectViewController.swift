//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by 前田 匠 on 2018/02/02.
//  Copyright © 2018年 前田 匠. All rights reserved.
//

import UIKit

class ImageSelectViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, AdobeUXImageEditorViewControllerDelegate{
    
    
    @IBAction func handleLibraryButton(_ sender: Any) {
        //ライブラリ(カメラコントロール）を指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
        {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(pickerController, animated:  true, completion: nil)
            
        }
        
    }
    @IBAction func handleCameraButton(_ sender: Any) {
        //カメラを指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.camera
            self.present(pickerController, animated:  true, completion: nil)
        }
    }
    @IBAction func hadleCancelButton(_ sender: Any) {
        
        //画面を閉じる
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            //撮影/選択された画像を取得する
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            //後でAdobeUXImageEditorを起動する
            //AdobeUXImageEditorで、受け取ったimageを加工できる
            //ここでpresentVIewControllerを呼び出しても表示されないためメソッドが終了してから呼ばれるようにする
            
            DispatchQueue.main.async {
                //AdobeImageEditorを起動する
                let adobeViewController = AdobeUXImageEditorViewController(image: image)
                adobeViewController.delegate = self
                self.present(adobeViewController,animated: true, completion: nil)
                
            }
        }
        
        //閉じる
        picker.dismiss(animated: true, completion: nil)
    }
    
    //フォトライブラリやカメラ起動中にキャンセルされたときに呼ばれるメソッド
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //閉じる
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    
    //AdobeImageEditorで加工が終わった時に呼ばれるメソッド
    func photoEditor (_ editor: AdobeUXImageEditorViewController, finishedWith image: UIImage?) {
        //画像加工画面を閉じる
        editor.dismiss(animated: true, completion: nil)
        
        //投稿画面を開く
       // let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "post")as! PostViewController
        
      //  PostViewController.image = image
       // present(PostViewController, animated: true, completion: nil)
       
        // 投稿の画面を開く
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
        postViewController.image = image
        present(postViewController, animated: true, completion: nil)
    }
    
    //AdobeImageEditorで加工をキャンセルした時によばれる
   // func photoEditorCanceled(_editor: AdobeUXImageEditorViewController) {
        //加工画面を閉じる
      //  editor.dismiss(animated: true, completion: nil)
   
    // AdobeImageEditorで加工をキャンセルしたときに呼ばれる
    func photoEditorCanceled(_ editor: AdobeUXImageEditorViewController) {
        // 加工画面を閉じる
        editor.dismiss(animated: true, completion: nil)
    
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
