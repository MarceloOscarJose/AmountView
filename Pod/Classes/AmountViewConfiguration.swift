//
//  AmountViewConfiguration.swift
//  AmountView
//
//  Created by Marcelo Oscar José on 02/07/2018.
//  Copyright © 2018 Marcelo Oscar José. All rights reserved.
//

import UIKit

open class AmountViewConfiguration: NSObject {
    public var verticalAlign: AmountViewVerticalAlign = .middle
    public var horizontalAlign: AmountViewHorizontalAlign = .center
    public var invalidAnimation: AmountViewInvalidAnimation = .shake

    public var userNativeKeyboard: Bool = true

    public var prefix: String = "$"
    public var thousandSeparator = "."
    public var decimals: Int = 0
    public var initialValue: Decimal = 0
    public var minEnabledValue: Decimal = 0
    public var maxEnabledValue: Decimal = 1000

    public var maxDigitFontSize: CGFloat = 120
    public var digitFont: UIFont = UIFont.systemFont(ofSize: 120, weight: .light)
    public var superScriptDigitFont: UIFont = UIFont.systemFont(ofSize: 60, weight: .regular)

    public var invalidDigitColor: UIColor = UIColor.lightGray
    public var normnalDigitColor: UIColor = UIColor.black
}

public enum AmountViewVerticalAlign {
    case top
    case middle
    case bottom
}

public enum AmountViewHorizontalAlign {
    case left
    case center
    case right
}

public enum AmountViewInvalidAnimation {
    case shake
    case bounce
    case none
}

public protocol AmountViewDelegate {
    func didAppendDigit()
    func didDeleteDigit()
    func minAmountInvalid()
    func maxAmountInvalid()
}
