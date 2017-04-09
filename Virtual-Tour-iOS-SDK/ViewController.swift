//
//  ViewController.swift
//  Virtual-Tour-iOS-SDK
//
//  Copyright © 2017 EyeSpy360. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, EyeSpy360ViewControllerDelegate {

    @IBOutlet var virtualTourUrlTextField: UITextField!
    
    private let params = [
        "key": "key", // Your key from 'API Credentials' in 'My Company' section
        "secret": "secret", // Your secret from 'API Credentials' in 'My Company' section
        "externalTourID": "my_unique_tour_id",
        "tour": "my_tour_title",
        "hl": "en" // Language
    ]
    
    private var tourEditorUrl: URL? {
        var components = URLComponents(string: "https:/e3.eyespy360.com/embed/tour-editor")
        
        components?.queryItems = params.map { URLQueryItem(name: $0.0, value: $0.1) }
        
        return components?.url
    }
    
    @IBAction func showTourEditor(_ sender: Any) {
        guard let url = tourEditorUrl else {
            print("Invalid URL")
            return
        }
        
        let eyeSpyViewController = EyeSpy360ViewController()
        eyeSpyViewController.url = url
        eyeSpyViewController.delegate = self
        
        navigationController?.pushViewController(eyeSpyViewController, animated: true)
    }
    
    func eyeSpy360(_ viewController: EyeSpy360ViewController, didPublishAt url: URL) {
        virtualTourUrlTextField.text = url.absoluteString
    }
    
    func eyeSpy360DidClose(_ viewController: EyeSpy360ViewController) {
        navigationController?.popViewController(animated: true)
    }
    
}
