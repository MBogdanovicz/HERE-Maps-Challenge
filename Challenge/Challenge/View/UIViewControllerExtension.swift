//
//  UIViewControllerExtension.swift
//  Challenge
//
//  Created by Marcelo Bogdanovicz on 02/09/19.
//  Copyright © 2019 Critical TechWorks. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showError(_ error: Error) {
        let hereError: HEREError
        
        if let error = error as? HEREError {
            hereError = error
        } else {
            hereError = HEREError(error: NSLocalizedString("Error", comment: ""), description: error.localizedDescription)
        }
        
        let controller = UIAlertController(title: hereError.error, message: hereError.description, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        controller.addAction(okAction)
        present(controller, animated: true)
    }
}
