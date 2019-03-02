//
//  AmountView+Images.swift
//  AmountView
//
//  Created by Marcelo Oscar José on 02/07/2018.
//  Copyright © 2018 Marcelo Oscar José. All rights reserved.
//

import UIKit

extension AmountView {

    func calculateDigitSize(digit: String,font: UIFont, fontSize: CGFloat) -> CGSize {
        return digit.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: font.fontName, size: fontSize)!])
    }

    func createSizeCache() {
        for char in validChars {
            self.sizeCache[char] = self.calculateDigitSize(digit: char, font: self.configuration.digitFont, fontSize: 1)
        }
    }

    func createImageCache() {

        self.createSizeCache()

        for char in validChars {
            if let digitSize = self.sizeCache[char] {
                let digitLayer = self.getImageLayer(isSuperScript: false, width: digitSize.width, height: digitSize.height, digit: char)
                let scriptDigitLayer = self.getImageLayer(isSuperScript: true, width: digitSize.width, height: digitSize.height, digit: char)

                self.imageCache[char] = self.layerToImage(textLayer: digitLayer)
                self.scriptImageCache[char] = self.layerToImage(textLayer: scriptDigitLayer)
            }
        }
    }

    func getImageLayer(isSuperScript: Bool, width: CGFloat, height: CGFloat, digit: String) -> CATextLayer {
        let font = isSuperScript ? self.configuration.superScriptDigitFont : self.configuration.digitFont
        let layerSize = CGSize(width: width * self.configuration.maxDigitFontSize, height: height * self.configuration.maxDigitFontSize)
        return self.textToLayer(digit: digit, font: font, fontSize: self.configuration.maxDigitFontSize, size: layerSize)
    }

    func textToLayer(digit: String, font: UIFont, fontSize: CGFloat, size: CGSize) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.font = CTFontCreateWithName((font.fontName as CFString?)!, fontSize, nil)
        textLayer.fontSize = fontSize
        textLayer.string = digit
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        return textLayer
    }

    func layerToImage(textLayer: CATextLayer) -> UIImage? {
        UIGraphicsBeginImageContext(textLayer.bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            textLayer.render(in: context)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysTemplate)
            UIGraphicsEndImageContext()
            return nameImage
        }

        return nil
    }
}
