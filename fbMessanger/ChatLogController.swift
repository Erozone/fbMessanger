//
//  ChatLogController.swift
//  fbMessanger
//
//  Created by Mohit Kumar on 24/12/16.
//  Copyright © 2016 Mohit Kumar. All rights reserved.
//

import UIKit

class ChatLogController : UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var messages : [Message]?
    
    let cellId = "cellId"
    
    var bottomContraints: NSLayoutConstraint?
    
    var friend : Friend?{
        
        didSet{
            navigationItem.title = friend?.name
            
            messages = friend?.messages?.allObjects as? [Message]
            messages = messages?.sorted(by: { $0.date?.compare($1.date as! Date) == .orderedAscending }) // This will sort the message with their time in the collectioView
        }
    }
    
    let messageInputContainerView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message.."
        return textField
    }()
    
    let sendButton : UIButton = {
       let button = UIButton()
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    private func setupInputComponents(){
        
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 1)
        
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(topBorderView)
        
        messageInputContainerView.addContraintsWithFormat(format: "H:|-8-[v0][v1(60)]|", views: inputTextField,sendButton)
        
        messageInputContainerView.addContraintsWithFormat(format: "V:|[v0]|", views: inputTextField)
        messageInputContainerView.addContraintsWithFormat(format: "V:|[v0]|", views: sendButton)
        
        messageInputContainerView.addContraintsWithFormat(format: "H:|[v0]|", views: topBorderView)
        messageInputContainerView.addContraintsWithFormat(format: "V:|[v0(0.5)]", views: topBorderView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubview(messageInputContainerView)
        
        
        view.addContraintsWithFormat(format: "H:|[v0]|", views: messageInputContainerView)
        view.addContraintsWithFormat(format: "V:[v0(48)]", views: messageInputContainerView)
        
        bottomContraints = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomContraints!)
        
        setupInputComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardNotification(notification: NSNotification){
        
        if let userInfo = notification.userInfo{
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
            print(keyboardFrame!)
            
            let isKeyboardShowing = notification.name == .UIKeyboardWillShow
            
            bottomContraints?.constant = isKeyboardShowing ? -(keyboardFrame?.height)! : 0
            
            UIView.animate(withDuration: 0, animations: { self.view.layoutIfNeeded()}, completion: {
                (completed) in
                
                if isKeyboardShowing{
                    let indexPath = NSIndexPath(item: self.messages!.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                }
            })
        }
    }
    
    
//    MARK:- CollectioView DataSource and Delegates

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count{
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ChatLogMessageCell
        cell?.messageTextView.text = messages?[indexPath.item].text
        
        if let message = messages?[indexPath.item], let messageText = message.text,let profileImageName = message.friend?.profileImageName {
            
            cell?.profileImageView.image = UIImage(named: profileImageName)
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName :UIFont.systemFont(ofSize: 18)], context: nil)
        
            if !message.isSender{
                cell?.messageTextView.frame = CGRect(x: 48+8, y: 0, width: estimatedFrame.width + 16 , height: estimatedFrame.height + 20)
                cell?.textBubbleView.frame = CGRect(x: 48, y: 0, width: estimatedFrame.width + 16 + 8 , height: estimatedFrame.height + 20)
                cell?.profileImageView.isHidden = false
                cell?.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                cell?.messageTextView.textColor = UIColor.black
            }else{
                cell?.messageTextView.frame = CGRect(x: view.frame.width-estimatedFrame.width - 16 - 16, y: 0, width: estimatedFrame.width + 16 , height: estimatedFrame.height + 20)
                cell?.textBubbleView.frame = CGRect(x: view.frame.width-estimatedFrame.width - 16 - 8 - 16, y: 0, width: estimatedFrame.width + 16 + 8 , height: estimatedFrame.height + 20)
                cell?.profileImageView.isHidden = true
                cell?.textBubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                cell?.messageTextView.textColor = UIColor.white
            }
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let messageText = messages?[indexPath.item].text{
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName :UIFont.systemFont(ofSize: 18)], context: nil)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
}



class ChatLogMessageCell : BaseClass{

    let messageTextView : UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = "Sample Message"
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    let textBubbleView :UIView = {
        let view = UIView()
       view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
//    let bubbleImageView : UIImageView = {
//       let imageView = UIImageView()
//        imageView.image = UIImage(named: "Bubble_grey")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22,left: 26,bottom: 15,right: 26))
//        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
//        return imageView
//    }()
    
    override func setupView() {
        super.setupView()
        
//        backgroundColor = UIColor.lightGray
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
        
        addSubview(profileImageView)
        addContraintsWithFormat(format: "H:|-8-[v0(30)]", views: profileImageView)
        addContraintsWithFormat(format: "V:[v0(30)]|", views: profileImageView)
        profileImageView.backgroundColor = UIColor.red
        
//        textBubbleView.addSubview(bubbleImageView)
//        textBubbleView.addContraintsWithFormat(format: "H:|[v0]|", views: bubbleImageView)
//        textBubbleView.addContraintsWithFormat(format: "V:|[v0]|", views: bubbleImageView)
    }
}

