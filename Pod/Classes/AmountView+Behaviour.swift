//
//  AmountView+Behaviour.swift
//  AmountView
//
//  Created by Marcelo Oscar José on 02/07/2018.
//  Copyright © 2018 Marcelo Oscar José. All rights reserved.
//

import UIKit

extension AmountView: UITextFieldDelegate {

    public func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        if self.hiddenTextField == textField {
            if string == "" {
                self.deleteDigit()
            } else if let digit = Int(string) {
                self.appendDigit(digit)
            } else {
                return false
            }
        }

        return true
    }

    public func getNumberDigits(_ digit: Int) -> [String] {
        var digits = self.digits

        if digits[0] == "0" {
            digits.removeFirst()
        }

        digits.append("\(digit)")
        return digits
    }

    public func appendDigit(_ digit: Int) {
        self.createTimer()

        let digitsCount = self.digits.count
        let numberCount = self.digitsCollectionView.visibleCells.count
        let newNumber = self.formatedAmount(amount: self.getNumberDigits(digit))

        if self.configuration.maxEnabledValue.isLess(than: newNumber) || (newNumber.isEqual(to: 0) && digit == 0) {
            self.invalidAnimate()
            return
        }

        self.digits = self.getNumberDigits(digit)
        self.insertedDigits += 1

        if self.insertedDigits < numberCount {
            self.performUpdate(deletePath: numberCount - self.insertedDigits, insertPath: digitsCount)
        } else {
            self.performUpdate(deletePath: 0, insertPath: numberCount)
        }

        if self.configuration.decimals > 0 && self.insertedDigits >= digitsCount {
            self.performMove(at: self.insertedDigits, to: self.insertedDigits)
        }
    }

    public func deleteDigit() {
        self.createTimer()

        let number = self.getAmount()

        if number == 0 {
            self.invalidAnimate()
            return
        }

        self.digits.removeLast()
        let numberCount = self.digits.count + 1
        let digitsCount = self.digits.count
        let position = self.configuration.decimals > 0 ? 1 : 0

        if number < 0.1 {
            self.digits.insert("\(0)", at: self.digits.count - 1)

            let insertPath = numberCount + position - 2
            self.performUpdate(deletePath: insertPath, insertPath: insertPath)
        } else if number < 1 {
            self.digits.insert("\(0)", at: self.digits.count - 2)

            let deletePath = numberCount + position - 2
            let insertPath = numberCount + position - 3
            self.performUpdate(deletePath: deletePath, insertPath: insertPath)
        } else if digitsCount < 1 + self.configuration.decimals {
            self.digits.insert("\(0)", at: 0)

            let deletePath = numberCount + position
            let insertPath = 1

            self.performUpdate(deletePath: deletePath, insertPath: insertPath)

            if self.configuration.decimals > 0 {
                let moveAt = numberCount + position - 3
                let moveTo = numberCount + position - 3
                self.performMove(at: moveAt, to: moveTo)
            }
        } else {
            self.performDelete(deletePath: numberCount)

            if self.configuration.decimals > 0 {
                let moveAt = numberCount + position - 3
                let moveTo = numberCount - 2
                self.performMove(at: moveAt, to: moveTo)
            }
        }
    }

    func createTimer() {
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0 / 60.0, target: self, selector: #selector(self.updateCells), userInfo: nil, repeats: true)
        }
    }

    func invalidateTimer() {
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
    }

    @objc func updateCells() {
        for cell in self.digitsCollectionView.visibleCells {
            let currentCell = (cell as! AmountViewCollectionViewCell)

            if let height = self.sizeCache[currentCell.stringDigit]?.height {
                if let imageDigit = currentCell.isSuperDigit ? self.scriptImageCache[currentCell.stringDigit] : self.imageCache[currentCell.stringDigit] {
                    currentCell.updateFrames(height: height * self.maxDigitFontSize, digitImage: imageDigit)
                    currentCell.digitImageView.tintColor = self.isValidAmount() ? self.configuration.normnalDigitColor : self.configuration.invalidDigitColor
                }
            }
        }
    }

    func performInsert(insertPath: Int) {
        digitsCollectionView.performBatchUpdates({
            digitsCollectionView.insertItems(at: [IndexPath(row: insertPath, section: 0)])
            //self.updateCells()
        }) { (_) in
            //self.updateCells()
        }
    }

    func performDelete(deletePath: Int) {
        digitsCollectionView.performBatchUpdates({
            digitsCollectionView.deleteItems(at: [IndexPath(row: deletePath, section: 0)])
            //self.updateCells()
        }) { (_) in
            //self.updateCells()
        }
    }

    func performMove(at: Int, to: Int) {
        digitsCollectionView.performBatchUpdates({
            digitsCollectionView.moveItem(at: IndexPath(row: at, section: 0), to: IndexPath(row: to, section: 0))
            //self.updateCells()
        }) { (_) in
            //self.updateCells()
        }
    }

    func performUpdate(deletePath: Int, insertPath: Int) {
        digitsCollectionView.performBatchUpdates({
            if deletePath > 0 {
                digitsCollectionView.deleteItems(at: [IndexPath(row: deletePath, section: 0)])
            }
            digitsCollectionView.insertItems(at: [IndexPath(row: insertPath, section: 0)])
            //self.updateCells()
        }) { (_) in
            //self.updateCells()
        }
    }
}
