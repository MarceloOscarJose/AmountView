//
//  AmountViewCollectionVIew.swift
//  AmountView
//
//  Created by Marcelo Oscar José on 02/07/2018.
//  Copyright © 2018 Marcelo Oscar José. All rights reserved.
//

import UIKit

class AmountViewCollectionVIew: UICollectionView {

    convenience init(cellIdentifier: String) {
        self.init(frame: .zero, collectionViewLayout: AmountViewCollectionLayout())

        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.isScrollEnabled = false
        self.backgroundColor = UIColor.clear
        self.register(AmountViewCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
}
