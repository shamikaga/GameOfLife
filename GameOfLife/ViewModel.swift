//
//  ViewModel.swift
//  GameOfLife
//
//  Created by Shamik Aga on 4/4/19.
//  Copyright © 2019 Shamik Aga. All rights reserved.
//

import Foundation

class ViewModel {

    let cellModels: [CellModel]

    init(numberOfCellsInRow: Int) {

        var cellModels = [CellModel]()

        let numberOfCells = numberOfCellsInRow * numberOfCellsInRow

        for i in 0...numberOfCells - 1 {
            let x = i % numberOfCellsInRow
            let y = Int(i / numberOfCellsInRow)

            var neighbors = [Index]()

            if x > 0 {
                neighbors.append(Index(x: x-1, y: y))
            }

            if x+1 < numberOfCellsInRow {
                neighbors.append(Index(x: x+1, y: y))
            }

            if y > 0 {
                neighbors.append(Index(x: x, y: y - 1))

                if x > 0 {
                    neighbors.append(Index(x: x-1, y: y - 1))
                }

                if x+1 < numberOfCellsInRow {
                    neighbors.append(Index(x: x+1, y: y - 1))
                }
            }

            if y+1 < numberOfCellsInRow {
                neighbors.append(Index(x: x, y: y+1))

                if x > 0 {
                    neighbors.append(Index(x: x-1, y: y+1))
                }

                if x+1 < numberOfCellsInRow {
                    neighbors.append(Index(x: x+1, y: y+1))
                }
            }

            let model = CellModel(status: .dead, index: Index(x: x, y: y), neighbors: neighbors)
            cellModels.append(model)
        }

        self.cellModels = cellModels
    }
}
