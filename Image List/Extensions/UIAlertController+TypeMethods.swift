//
//  UIAlertController+TypeMethods.swift
//  Image List
//
//  Created by Asim on 14/02/21.
//  Copyright © 2021 Asim. All rights reserved.
//

import UIKit

extension UIAlertController {
    class func show(title: String?, message: String, from controller: UIViewController) {
        show(title: title, message: message, from: controller, buttons: [("Ok", nil)])
    }
    
    class func show(title: String?, message: String, from controller: UIViewController, buttons: [(title: String, action: (() -> Void)?)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for button in buttons {
            alert.addAction(UIAlertAction(title: button.title, style: .default, handler: { (_) in
                button.action?()
            }))
        }
        
        controller.present(alert, animated: true, completion: nil)
    }
}
