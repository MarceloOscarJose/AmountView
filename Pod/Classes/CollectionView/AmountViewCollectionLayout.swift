//
//  AmountViewAlignedLayout.swift
//  AmountView
//
//  Created by Marcelo Oscar José on 02/07/2018.
//  Copyright © 2018 Marcelo Oscar José. All rights reserved.
//

import UIKit

class AmountViewCollectionLayout: UICollectionViewFlowLayout {

    var insertIndexPaths = NSMutableArray()
    var deleteIndexPaths = NSMutableArray()
    var center = CGPoint.zero

    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)

        self.deleteIndexPaths.removeAllObjects()
        self.insertIndexPaths.removeAllObjects()

        for update in updateItems {
            if update.updateAction == UICollectionViewUpdateItem.Action.delete {
                self.deleteIndexPaths.add(update.indexPathBeforeUpdate!)
            } else if update.updateAction == UICollectionViewUpdateItem.Action.insert {
                self.insertIndexPaths.add(update.indexPathAfterUpdate!)
            }
        }
    }

    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()

        self.deleteIndexPaths.removeAllObjects()
        self.insertIndexPaths.removeAllObjects()
    }

    override func initialLayoutAttributesForAppearingItem(
        at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes: UICollectionViewLayoutAttributes? = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)

        if self.insertIndexPaths.contains(itemIndexPath) {
            if attributes == nil {
                attributes = layoutAttributesForItem(at: itemIndexPath)
            }

            attributes!.center = CGPoint(x: attributes!.center.x, y: attributes!.center.y - 30)
        }

        return attributes
    }

    override func finalLayoutAttributesForDisappearingItem(
        at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes: UICollectionViewLayoutAttributes? = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)

        if self.deleteIndexPaths.contains(itemIndexPath) {
            if attributes == nil {
                attributes = layoutAttributesForItem(at: itemIndexPath)
            }

            var center = attributes!.center
            center.y += 30

            attributes!.center = center
        }

        return attributes
    }
}
