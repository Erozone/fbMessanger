//
//  FriendsControllerHelper.swift
//  fbMessanger
//
//  Created by Mohit Kumar on 21/12/16.
//  Copyright © 2016 Mohit Kumar. All rights reserved.
//

import UIKit
import CoreData

extension FriendsController{
    
    private func createMessageWithText(text: String,friend :Friend,minuteAgo :Double,context:NSManagedObjectContext,isSender : Bool = false){
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.text = text
        message.date = NSDate().addingTimeInterval(-minuteAgo * 60)
        message.friend = friend
        message.isSender = NSNumber(booleanLiteral: isSender) as Bool
    }
    
    private func createSteveMessageWithContext(context :NSManagedObjectContext){
        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        steve.name = "Steve Jobs"
        steve.profileImageName = "Steve"
        
        createMessageWithText(text: "Hello!Good Morning..", friend: steve,minuteAgo :5, context: context)
        createMessageWithText(text: "How are you?  Hope you are having a good morning ..", friend: steve,minuteAgo : 4, context: context)
        createMessageWithText(text: "Are you interest in buying an apple product..We have a wide variety of apple device that suits your needs. Please make your purchase with us..", friend: steve,minuteAgo :3, context: context)
        createMessageWithText(text: "Totally understand that you want new iPhone 7,But You have to wait for September.Thats hows apple did works....", friend: steve,minuteAgo :1, context: context)
        
        // Response
        
        createMessageWithText(text: "Yes!!Totally looking to buy iPhone 7..", friend: steve,minuteAgo :2, context: context,isSender: true)
        createMessageWithText(text: "Ok Thanks for response,Untill then i will use my gigentic iphone 6 Plue..", friend: steve,minuteAgo :0, context: context,isSender: true)
    }
    
    
    private func fetchFriends()->[Friend]?{
        
        let delegat = UIApplication.shared.delegate as? AppDelegate
        if let context = delegat?.persistentContainer.viewContext {
            
            let fetchRequest :NSFetchRequest<Friend> = Friend.fetchRequest()
            do {
                
                return try(context.fetch(fetchRequest)) as? [Friend]
                
            }catch let err {
                print(err)
            }
        }
        
        return nil
    }
    
    func clearData(){
        let delegat = UIApplication.shared.delegate as? AppDelegate
        if let context = delegat?.persistentContainer.viewContext {
            
            do{
                let fetchRequest :NSFetchRequest<Message> = Message.fetchRequest() //This will request to fetch all the messages in DB
                
                let objects =  try(context.fetch(fetchRequest)) as? [Message]
                
                for object in objects!{
                    context.delete(object)
                }
                
                try(context.save())
            }catch let err{
                print(err)
            }
            
            do{
                let fetchReqest : NSFetchRequest<Friend> = Friend.fetchRequest() // This will request to fetch all the friends in DB
                
                let objects =  try(context.fetch(fetchReqest)) as? [Friend]
                
                for object in objects!{
                    context.delete(object)
                }
            }catch let err{
                print(err)
            }
            
        }
    }
    
    func loadData(){
        let delegat = UIApplication.shared.delegate as? AppDelegate
        if let context = delegat?.persistentContainer.viewContext {
            
            if let friends = fetchFriends(){
                
                messages = [Message]()
                
                for friend in friends{      // This will take each friend from friends array
                    print(friend.name!)
                    
                    let fetchRequest :NSFetchRequest<Message> = Message.fetchRequest()
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key :"date",ascending : false)]   // This will sort dates
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)    // This will give the single friend
                    fetchRequest.fetchLimit = 1  // This will limit the searchResult to have single message
                    
                    do{
                        let fetchResult = try(context.fetch(fetchRequest)) as? [Message]
                        messages?.append(contentsOf: fetchResult!)
                    }catch let err {
                        print(err)
                    }
                }
                
                messages = messages?.sorted(by: { $0.date?.compare($1.date as! Date) == .orderedDescending }) // This will sort the message with their time in the collectioView
                
            }
        }
    }
    
    func setupData(){
        
        clearData()
        
        let delegat = UIApplication.shared.delegate as? AppDelegate
         if let context = delegat?.persistentContainer.viewContext {
            
            
            let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            mark.name = "Mark Zukerberg"
            mark.profileImageName = "Mark"
            
            let donald = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            donald.name = "Donald Trump"
            donald.profileImageName = "Donald"
            
            createSteveMessageWithContext(context: context)
            
            let gandhi = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            gandhi.name = "Mahatma Gandhi"
            gandhi.profileImageName = "Gandhi"
            
            let hilary = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            hilary.name = "Hilary Cliton"
            hilary.profileImageName = "Hilary"
            
            
            createMessageWithText(text: "Hello I created Facebook.I am a CEO...", friend: mark, minuteAgo: 1, context: context)
            createMessageWithText(text: "You are Fired!!", friend: donald, minuteAgo: 4, context: context)
            createMessageWithText(text: "Love ,Peace and Joy", friend: gandhi, minuteAgo: 60 * 50, context: context)
            createMessageWithText(text: "Vote For Me.As you do for Bill", friend: hilary, minuteAgo: 8 * 60 * 24, context: context)
            
            
            do{
                try(context.save())
            }catch let err {
                print(err)
            }
        }
        
        loadData()
    }
    
}
