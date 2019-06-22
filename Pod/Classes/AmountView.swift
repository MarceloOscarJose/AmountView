//
//  AmountView.swift
//  AmountView
//
//  Created by Marcelo Oscar José on 02/07/2018.
//  Copyright © 2018 Marcelo Oscar José. All rights reserved.
//

import UIKit

public class AmountView: UIView {

    public var delegate: AmountViewDelegate!
    var configuration: AmountViewConfiguration!

    // Behaviour vars
    var maxDigitFontSize: CGFloat = 120
    var contentSize: CGSize = CGSize(width: 0, height: 0)
    var digits: [String] = []
    var validChars: [String] = []
    var sizeCache: [String: CGSize] = [:]
    var imageCache: [String: UIImage] = [:]
    var scriptImageCache: [String: UIImage] = [:]
    var insertedDigits: Int = 0

    // Constants
    let collectionviewCell: String = "DigitCollectionViewCell"

    // UI Controls
    var hiddenTextField: UITextField!
    var digitsCollectionView: AmountViewCollectionVIew!

    public convenience init(configuration: AmountViewConfiguration) {
        self.init(frame: .zero)
        self.delegate = self
        self.loadConfiguration(configuration: configuration)
    }

    public func loadConfiguration(configuration: AmountViewConfiguration) {
        if self.digitsCollectionView != nil {
            self.digitsCollectionView.removeFromSuperview()
            self.digitsCollectionView = nil
        }
        if self.hiddenTextField != nil {
            self.hiddenTextField.removeFromSuperview()
        }

        self.configuration = configuration
        self.setupControls()
        self.setupConstraints()

        self.createValidChars()
        self.maxDigitFontSize = configuration.maxDigitFontSize
        self.setAmount(amount: configuration.initialValue)

        self.createImageCache()
        digitsCollectionView.dataSource = self
        digitsCollectionView.delegate = self
    }

    public func setAmount(amount: Decimal) {
        self.digits = []
        let stringAmount = self.truncateAmount(amount: amount)
        self.digits = stringAmount.description.map { String($0) }
        self.digitsCollectionView.reloadData()
        self.hiddenTextField.text = stringAmount.description

        self.insertedDigits = 0
        if !amount.isZero {
            self.insertedDigits = self.digits.count
        }
    }

    public func getAmount() -> Decimal {
        var beforeDigits = self.digits
        beforeDigits.removeAll(where: {$0 == self.configuration.thousandSeparator})
        return self.formatedAmount(amount: beforeDigits)
    }

    public func isMinValidAmount() -> Bool {
        let number = self.getAmount()
        if number.isLess(than: self.configuration.minEnabledValue) {
            return false
        }

        return true
    }

    public func validateAmount() {
        let number = self.getAmount()
        if !number.isLess(than: self.configuration.minEnabledValue) && !number.isZero {
            delegate.didEnterValidAmount()
        }
    }

    public func formatedAmount(amount: [String]) -> Decimal {
        var stringAmount = amount.joined()

        if self.configuration.decimals > 0 {
            stringAmount.insert(".", at: stringAmount.index(stringAmount.startIndex, offsetBy: stringAmount.count - self.configuration.decimals))
        }

        return Decimal(string: stringAmount)!
    }

    func isSuperScript(index: IndexPath) -> Bool {
        if index.item == 0 || index.item >= (self.digits.count + 1 - self.configuration.decimals) {
            return true
        }
        return false
    }

    func truncateAmount(amount: Decimal) -> String {
        let decimalPlaces: Int = self.configuration.decimals > 0 ? self.configuration.decimals + 1 : 0

        let formater = NumberFormatter()
        formater.groupingSeparator = self.configuration.thousandSeparator
        formater.decimalSeparator = ""
        formater.numberStyle = .decimal
        formater.maximumFractionDigits = decimalPlaces
        formater.minimumFractionDigits = decimalPlaces
        formater.roundingMode = .down

        var stringAmount = formater.string(from: amount as NSNumber)!

        if decimalPlaces > 0 {
            stringAmount.removeLast()
        }

        return stringAmount
    }

    fileprivate func setupControls() {
        self.digitsCollectionView = AmountViewCollectionVIew(cellIdentifier: self.collectionviewCell)
        self.addSubview(digitsCollectionView)

        if self.configuration.userNativeKeyboard {
            self.hiddenTextField = UITextField()
            self.hiddenTextField.delegate = self
            self.hiddenTextField.keyboardType = .decimalPad
            self.hiddenTextField.becomeFirstResponder()
            self.addSubview(hiddenTextField)

            digitsCollectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showKeyaboard)))
        }
    }

    fileprivate func setupConstraints() {
        hiddenTextField.widthAnchor.constraint(equalToConstant: 1)
        hiddenTextField.heightAnchor.constraint(equalToConstant: 1)
        hiddenTextField.topAnchor.constraint(equalTo: self.topAnchor)
        hiddenTextField.leftAnchor.constraint(equalTo: self.leftAnchor)
        digitsCollectionView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }

    @objc fileprivate func showKeyaboard() {
        self.bounce()
        self.hiddenTextField.becomeFirstResponder()
    }

    fileprivate func createValidChars() {
        self.validChars = [self.configuration.prefix, self.configuration.thousandSeparator]

        for digit in 0...9 {
            self.validChars.append(digit.description)
        }
    }
}

// Mark: Delegate
extension AmountView: AmountViewDelegate {

    public func didAppendDigit() {
        // Override on delegate
    }

    public func didDeleteDigit() {
        // Override on delegate
    }

    public func minAmountInvalid() {
        // Override on delegate
    }

    public func didEnterValidAmount() {
        // Override on delegate
    }
}
