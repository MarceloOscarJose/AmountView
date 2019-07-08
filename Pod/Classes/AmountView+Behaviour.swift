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
            if string.isEmpty {
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

        let numberCount = self.digitsCollectionView.visibleCells.count
        let newNumber = self.formatedAmount(amount: self.getNumberDigits(digit))

        if self.configuration.maxEnabledValue.isLess(than: newNumber) || (newNumber.isEqual(to: 0) && digit == 0) {
            self.invalidAnimate()
            return
        }

        delegate.didAppendDigit()
        self.digits = self.getNumberDigits(digit)
        self.insertedDigits += 1

        if self.insertedDigits < numberCount {
            self.performUpdate(deletePath: numberCount - self.insertedDigits, insertPath: self.digits.count)
        } else {
            self.performUpdate(deletePath: 0, insertPath: numberCount)
        }

        if self.configuration.decimals > 0 && self.insertedDigits >= self.digits.count {
            self.moveDigits()
        }

        //self.updatethousandSeparators()
    }

    public func deleteDigit() {

        let number = self.getAmount()

        if number.isEqual(to: 0) {
            self.invalidAnimate()
            return
        }

        if let delegate = self.delegate {
            delegate.didDeleteDigit()
        }

        self.insertedDigits -= 1
        self.digits.removeLast()
        self.performDelete(deletePath: self.digits.count + 1)

        if self.digits.count <= self.configuration.decimals {

            let insertZero = 1 + self.configuration.decimals - self.insertedDigits
            self.digits.insert("\(0)", at: insertZero - 1)
            self.performInsert(insertPath: insertZero)

            self.moveDigits()
        }

        //self.updatethousandSeparators()
    }

    func updatethousandSeparators() {

        var position: Int = 0
        self.digits.forEach({digit in
            if digit == configuration.thousandSeparator {
                self.digits.remove(at: position)
                self.performDelete(deletePath: position + 1)
                self.insertedDigits -= 1
                position -= 1
                self.moveDigits()
            }

            position += 1
        })

        let finalDigits = self.truncateAmount(amount: self.formatedAmount(amount: self.digits)).map({ String($0) })

        position = 0
        self.digits.forEach({digit in
            if finalDigits[position] == configuration.thousandSeparator {
                self.digits.insert(finalDigits[position], at: position)
                self.performInsert(insertPath: position + 1)
                self.insertedDigits += 1
                position += 1
                self.moveDigits()
            }

            position += 1
        })
    }

    func moveDigits() {
        self.performMove(at: self.insertedDigits, to: self.insertedDigits)
    }

    func updateCells() {
        DispatchQueue.main.asyncAfter(deadline: .now() + (1.0 / 60.0)) {
            let tintColor = self.isMinValidAmount() ? self.configuration.normalDigitColor : self.configuration.invalidDigitColor

            self.digitsCollectionView.visibleCells.forEach({
                let currentCell = ($0 as! AmountViewCollectionViewCell)

                if let height = self.sizeCache[currentCell.stringDigit]?.height {
                    if let imageDigit = currentCell.isSuperDigit ? self.scriptImageCache[currentCell.stringDigit] : self.imageCache[currentCell.stringDigit] {
                        currentCell.updateFrames(height: height * self.maxDigitFontSize, digitImage: imageDigit)
                        currentCell.digitImageView.tintColor = tintColor
                    }
                }
            })
        }
    }

    func performInsert(insertPath: Int) {
        digitsCollectionView.performBatchUpdates({
            digitsCollectionView.insertItems(at: [IndexPath(row: insertPath, section: 0)])
            self.updateCells()
        }) { (_) in
            self.updateCells()
        }
    }

    func performDelete(deletePath: Int) {
        digitsCollectionView.performBatchUpdates({
            digitsCollectionView.deleteItems(at: [IndexPath(row: deletePath, section: 0)])
            self.updateCells()
        }) { (_) in
            self.updateCells()
        }
    }

    func performMove(at: Int, to: Int) {
        digitsCollectionView.performBatchUpdates({
            digitsCollectionView.moveItem(at: IndexPath(row: at, section: 0), to: IndexPath(row: to, section: 0))
            self.updateCells()
        }) { (_) in
            self.updateCells()
        }
    }

    func performUpdate(deletePath: Int, insertPath: Int) {
        digitsCollectionView.performBatchUpdates({
            if deletePath > 0 {
                digitsCollectionView.deleteItems(at: [IndexPath(row: deletePath, section: 0)])
                self.updateCells()
            }
            digitsCollectionView.insertItems(at: [IndexPath(row: insertPath, section: 0)])
            self.updateCells()
        }) { (_) in
            self.updateCells()
        }
    }
}
