//
//  AmountView+Animations.swift
//  AmountView
//
//  Created by Marcelo Oscar José on 02/07/2018.
//  Copyright © 2018 Marcelo Oscar José. All rights reserved.
//

import UIKit

extension AmountView {

    func animateInvalid() {
        switch self.configuration.invalidAnimation {
            case .none: break
            case .shake: self.shake()
            case .bounce: self.bounce()
        }
    }

    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.21
        animation.values = [7, -12, 7, -2, 0.0]
        self.digitsCollectionView.layer.add(animation, forKey: "shake")
    }

    func bounce() {
        UIView.animate(withDuration: 0.1, animations: {
            self.digitsCollectionView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.digitsCollectionView.transform = CGAffineTransform.identity
            }
        })
    }
}
