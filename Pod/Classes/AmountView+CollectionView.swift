//
//  AmountView+CollectionView.swift
//  AmountView
//
//  Created by Marcelo Oscar José on 02/07/2018.
//  Copyright © 2018 Marcelo Oscar José. All rights reserved.
//

import UIKit

extension AmountView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.digits.count + 1
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionviewCell, for: indexPath) as! AmountViewCollectionViewCell
        let digit: String = indexPath.item == 0 ? self.configuration.prefix : digits[indexPath.item - 1]
        let isSuperScript = self.isSuperScript(index: indexPath)

        if let digitImage = isSuperScript ? self.scriptImageCache[digit] : self.imageCache[digit], let digitSize = self.sizeCache[digit] {
            cell.setupCell(digitImage: digitImage, stringDigit: digit, isSuperDigit: isSuperScript, height: digitSize.height * self.digitFontSize)
            cell.digitImageView.tintColor = self.isValidAmount() ? self.configuration.normnalDigitColor : self.configuration.invalidDigitColor
        }

        return cell
    }

    // MARK: Layout delegate
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath.item == 0 {
            self.contentSize = CGSize(width: 0, height: 0)
        }

        let digit: String = indexPath.item == 0 ? self.configuration.prefix : digits[indexPath.item - 1]
        let isSuperDigit = self.isSuperScript(index: indexPath)

        var fontSize = self.configuration.maxDigitFontSize

        for _ in 0...Int(self.configuration.maxDigitFontSize) {
            let currentWidth = self.digits.map({ (self.sizeCache[$0]?.width)! * fontSize }).reduce(0, +) + ((self.sizeCache[self.configuration.prefix]?.width)! * (fontSize / 2))
            let currentHeight = (self.sizeCache["0"]?.height)! * fontSize
            
            if currentWidth < self.digitsCollectionView.frame.width && currentHeight < self.digitsCollectionView.frame.height {
                break;
            }
            fontSize -= 1
        }

        if let cell = collectionView.cellForItem(at: indexPath) as? AmountViewCollectionViewCell {
            cell.isSuperDigit = isSuperDigit
        }

        self.digitFontSize = fontSize

        if let frame = self.sizeCache[digit] {
            let frameWidth = frame.width * (isSuperDigit ? fontSize / 2 : fontSize)
            let frameHeight = frame.height * fontSize

            self.contentSize = CGSize(width: self.contentSize.width + frameWidth, height: frameHeight)
            return CGSize(width: frameWidth, height: frameHeight)
        }

        return CGSize(width: 0, height: 0)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        if self.configuration.horizontalAlign == .center {
            insets.left = (collectionView.frame.width - self.contentSize.width) / 2
            insets.right = (collectionView.frame.width - self.contentSize.width) / 2
        } else if self.configuration.horizontalAlign == .left {
            insets.right = collectionView.frame.width - self.contentSize.width
        } else {
            insets.left = collectionView.frame.width - self.contentSize.width
        }

        if self.configuration.verticalAlign == .middle {
            insets.top = (collectionView.frame.height - self.contentSize.height) / 2
            insets.bottom = (collectionView.frame.height - self.contentSize.height) / 2
        } else if self.configuration.verticalAlign == .bottom {
            insets.top = collectionView.frame.height - self.contentSize.height
        } else {
            insets.bottom = collectionView.frame.height - self.contentSize.height
        }

        return insets
    }
}
