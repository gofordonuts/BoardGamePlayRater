//
//  playerSegue.swift
//  BoardGamePlayRater
//
//  Created by William Beutel on 8/21/18.
//  Copyright © 2018 Maria Beutel. All rights reserved.
//

import UIKit

class playerSegue: UIStoryboardSegue {

    override func perform() {
        scale()
    }
    
    func scale () {
        let toVC = self.destination
        let fromVC = self.source
        
        let containerView = fromVC.view.superview
        let originalCenter = fromVC.view.center
        
        toVC.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        toVC.view.center = originalCenter
        
        containerView?.addSubview(toVC.view)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            toVC.view.transform = CGAffineTransform.identity
        }, completion: { (success) in
            fromVC.present(toVC, animated: false, completion: nil)
            })
    
   
    }
}

class UnwindScaleSegue: UIStoryboardSegue {
    override func perform() {
        scale()
    }
    
    func scale () {
        let toVC = self.destination
        let fromVC = self.source
        
        fromVC.view.superview?.insertSubview(toVC.view, at: 0)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            fromVC.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        }, completion: { (success) in
            fromVC.dismiss(animated: false, completion: nil)
        })
        
        
    }
}


