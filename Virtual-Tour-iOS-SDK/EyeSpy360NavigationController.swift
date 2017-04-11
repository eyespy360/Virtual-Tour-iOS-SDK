//
//  EyeSpy360NavigationController.swift
//  Virtual-Tour-iOS-SDK
//
//  Copyright © 2017 EyeSpy360. All rights reserved.
//

import UIKit

class EyeSpy360NavigationController: UINavigationController {
    private var shouldAnimate: Bool = false
    
    override var presentingViewController: UIViewController? {
        if shouldAnimate {
            return nil
        } else {
            return super.presentingViewController
        }
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if viewControllerToPresent is UIDocumentMenuViewController || viewControllerToPresent is UIImagePickerController {
            shouldAnimate = true
        }
        
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    func fixedDismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        
        shouldAnimate = false
        
        super.dismiss(animated: flag, completion: completion)
//        if presentedViewController != nil {
//            super.dismiss(animated: flag, completion: completion)
//        }
    }

}
