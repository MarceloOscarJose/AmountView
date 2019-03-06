//
//  MainViewController.swift
//  Test
//
//  Created by Marcelo Oscar José on 02/07/2018.
//  Copyright © 2018 Marcelo Oscar José. All rights reserved.
//

import AmountView
import PureLayout

class MainViewController: UIViewController, AmountViewDelegate {

    @IBOutlet weak var configurationStack: UIStackView!
    @IBOutlet weak var minValue: UITextField!
    @IBOutlet weak var maxValue: UITextField!
    @IBOutlet weak var initValue: UITextField!
    @IBOutlet weak var maxFontSize: UITextField!
    @IBOutlet weak var decimals: UITextField!
    @IBOutlet weak var prefix: UITextField!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var verticalAlign: UISegmentedControl!
    @IBOutlet weak var horizontalAlign: UISegmentedControl!
    @IBOutlet weak var invalidColor: UITextField!
    @IBOutlet weak var normalColor: UITextField!

    var amountView: AmountView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.amountView = AmountView(configuration: self.getConfigs())
        self.view.addSubview(amountView)

        amountView.autoPinEdge(.top, to: .top, of: self.view, withOffset: 0)
        amountView.autoSetDimension(.width, toSize: self.view.frame.width)
        amountView.autoPinEdge(.bottom, to: .top, of: configurationStack, withOffset: -20)

        amountView.layer.borderWidth = 1
        amountView.layer.borderColor = UIColor.black.cgColor
        applyButton.addTarget(self, action: #selector(appleyChanges), for: .touchUpInside)

        amountView.delegate = self
    }

    func getConfigs() -> AmountViewConfiguration {
        let amountViewConfigurtion = AmountViewConfiguration()

        if let decimalsText = decimals.text,
            let prefixText = self.prefix.text,
            let maxFontSizeText = self.maxFontSize.text,
            let minValueText = self.minValue.text,
            let maxValueText = self.maxValue.text,
            let initValueString = self.initValue.text,
            let invalidColorString = self.invalidColor.text,
            let normalColorString = self.normalColor.text {

            amountViewConfigurtion.decimals = Int(decimalsText)!
            amountViewConfigurtion.maxDigitFontSize = CGFloat(Int(maxFontSizeText)!)
            amountViewConfigurtion.digitFont = UIFont.systemFont(ofSize: 120, weight: .light)
            amountViewConfigurtion.superScriptDigitFont = UIFont.systemFont(ofSize: 60, weight: .regular)
            amountViewConfigurtion.maxEnabledValue = Decimal(string: maxValueText)!
            amountViewConfigurtion.minEnabledValue = Decimal(string: minValueText)!
            amountViewConfigurtion.horizontalAlign = horizontalAlign.selectedSegmentIndex == 0 ? .center : horizontalAlign.selectedSegmentIndex == 1 ? .left : .right
            amountViewConfigurtion.verticalAlign = verticalAlign.selectedSegmentIndex == 0 ? .middle : verticalAlign.selectedSegmentIndex == 1 ? .top : .bottom
            amountViewConfigurtion.prefix = prefixText
            amountViewConfigurtion.initialValue = Decimal(string: initValueString)!
            amountViewConfigurtion.userNativeKeyboard = true
            amountViewConfigurtion.invalidDigitColor = self.hexStringToUIColor(hex: invalidColorString)
            amountViewConfigurtion.normalDigitColor = self.hexStringToUIColor(hex: normalColorString)
        }

        return amountViewConfigurtion
    }

    @objc func appleyChanges() {
        self.amountView.loadConfiguration(configuration: self.getConfigs())
    }

    func hexStringToUIColor(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    func didAppendDigit() {
    }

    func didDeleteDigit() {
    }

    func didEnterValidAmount() {
    }
}
