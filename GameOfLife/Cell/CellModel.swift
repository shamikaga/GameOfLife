//
//  CellModel.swift
//  GameOfLife
//
//  Created by Shamik Aga on 4/3/19.
//  Copyright © 2019 Shamik Aga. All rights reserved.
//

import Foundation
import UIKit

enum Status {
    case alive, dead

    var color: UIColor {
        switch self {
        case .alive:
            return .white
        case .dead:
            return .clear
        }
    }
}

struct Index {
    let x: Int
    let y: Int
}

class CellModel {

    var status: Status
    let index: Index
    let neighbors: [Index]

    init(status: Status, index: Index, neighbors: [Index]) {
        self.status = status
        self.index = index
        self.neighbors = neighbors
    }
}
