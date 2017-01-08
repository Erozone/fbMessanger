//
//  CustomTabBarController.swift
//  fbMessanger
//
//  Created by Mohit Kumar on 25/12/16.
//  Copyright © 2016 Mohit Kumar. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the custom tab bar controller
        
        let layout = UICollectionViewFlowLayout()
        let friendsController = FriendsController(collectionViewLayout: layout)
        let recentMessageController = UINavigationController(rootViewController: friendsController)
        recentMessageController.tabBarItem.title = "Recent"
        recentMessageController.tabBarItem.image = UIImage(named: "recent")
                
        viewControllers = [recentMessageController,createDummyNavContoller(title: "Calls", ImageName: "calls"),createDummyNavContoller(title: "Groups", ImageName: "groups"),createDummyNavContoller(title: "People", ImageName: "people"),createDummyNavContoller(title: "Setting", ImageName: "setting")]
        
    }
    
    private func createDummyNavContoller(title : String,ImageName :String)-> UINavigationController{
        let uiController = UIViewController()
        let navController = UINavigationController(rootViewController: uiController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: ImageName)
        return navController
    }
    
}
