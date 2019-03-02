//
//  AmountViewCollectionViewCell.swift
//  AmountView
//
//  Created by Marcelo Oscar José on 02/07/2018.
//  Copyright © 2018 Marcelo Oscar José. All rights reserved.
//

import UIKit

class AmountViewCollectionViewCell: UICollectionViewCell {

    var digitImageView: UIImageView = {
        let digitImage = UIImageView()
        digitImage.contentMode = .scaleAspectFit
        return digitImage
    }()

    var stringDigit: String!
    var isSuperDigit: Bool = false

    func setupCell(digitImage: UIImage, stringDigit: String, isSuperDigit: Bool, height: CGFloat) {
        self.stringDigit = stringDigit
        self.isSuperDigit = isSuperDigit

        self.contentView.addSubview(self.digitImageView)
        self.digitImageView.image = digitImage
        self.digitImageView.frame = self.getDigitFrame(height: height)
    }

    func updateFrames(height: CGFloat, digitImage: UIImage) {
        let digitFrame = self.getDigitFrame(height: height)

        if self.digitImageView.frame != digitFrame {
            self.animateResize(digitFrame: digitFrame)
        }
        if self.digitImageView.image != digitImage {
            self.animateImageChange(imageFrom: self.digitImageView.image!, imageTo: digitImage)
        }
    }

    func getDigitFrame(height: CGFloat) -> CGRect {
        let digitHeight = self.isSuperDigit ? self.contentView.frame.height / 2 : self.contentView.frame.height
        let originY = self.isSuperDigit ? (digitHeight / 4) : 0

        return CGRect(x: 0, y: originY, width: self.contentView.frame.width, height: digitHeight)
    }

    func animateResize(digitFrame: CGRect) {
        UIView.animate(withDuration: 0.3, animations: {
            self.digitImageView.frame = digitFrame
        })
    }

    func animateImageChange(imageFrom: UIImage, imageTo: UIImage) {
        let fadeIn: CABasicAnimation = CABasicAnimation(keyPath: "contents")
        fadeIn.fromValue = imageFrom
        fadeIn.toValue = imageTo
        fadeIn.duration = 0.1
        self.digitImageView.layer.add(fadeIn, forKey: "contents")
        self.digitImageView.image = imageTo
    }
}
