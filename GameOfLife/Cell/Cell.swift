//
//  Cell.swift
//  GameOfLife
//
//  Created by Shamik Aga on 3/31/19.
//  Copyright © 2019 Shamik Aga. All rights reserved.
//

import Foundation
import UIKit

class Cell: UICollectionViewCell {

    struct Constants {
        static let borderWidth = CGFloat(0.5)
        static let borderColor = UIColor.black.cgColor
    }

    var model: CellModel? {
        didSet {
            backgroundColor = model?.status.color
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.borderWidth = Constants.borderWidth
        layer.borderColor = Constants.borderColor
    }
}
