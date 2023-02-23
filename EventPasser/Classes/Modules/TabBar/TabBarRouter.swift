//
//  TabBarRouter.swift
//  EventPasser
//
//  Created by Arseniy Matus on 21.10.2022.
//  
//

import Foundation
import UIKit

class TabBarRouter {
    
    // MARK: Static methods
    static func createModule() -> UIViewController {
        let viewController = TabBarViewController()
        
        return viewController
    }
    
}
