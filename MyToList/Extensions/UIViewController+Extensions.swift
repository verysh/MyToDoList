//
//  UIViewController+Extensions.swift
//  MyToList
//
//  Created by Vladimir Eryshev on 28.07.2025.
//

import Foundation
import UIKit

extension UIViewController {
    func displayMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func displayShareVC(_ items: [String]) {
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
}
