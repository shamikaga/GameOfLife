//
//  Controller.swift
//  GameOfLife
//
//  Created by Shamik Aga on 4/4/19.
//  Copyright © 2019 Shamik Aga. All rights reserved.
//

import Foundation

protocol ControllerProtocol: class {
    var viewModel: ViewModel { get }
    var numberOfCells: Int { get }
    func didSelectCell(atIndexPath indexPath: IndexPath)
    func playGame()
    func pauseGame()
}

class Controller: ControllerProtocol {

    let viewModel: ViewModel
    let numberOfCells: Int
    let numberOfCellsInRow: Int
    weak var view: ViewProtocol?

    fileprivate var timer: Timer?

    init(numberOfCellsInRow: Int, inView view: ViewProtocol) {
        let viewModel = ViewModel(numberOfCellsInRow: numberOfCellsInRow)

        self.viewModel = viewModel
        self.numberOfCellsInRow = numberOfCellsInRow
        self.numberOfCells = numberOfCellsInRow * numberOfCellsInRow
        self.view = view
    }

    private func computeNextStage() -> [IndexPath] {
        var indexToStatus = [Int: Status]()
        let models = viewModel.cellModels

        for i in 0...numberOfCells - 1 {
            let model = models[i]

            var aliveNeighbors = 0

            for index in model.neighbors {
                let modelIndex = index.x + Int(index.y * numberOfCellsInRow)

                let neighbor = models[modelIndex]
                if neighbor.status == .alive {
                    aliveNeighbors = aliveNeighbors + 1
                }
            }

            if model.status == .alive {
                if aliveNeighbors < 2 {
                    indexToStatus[i] = .dead
                } else if aliveNeighbors > 3 {
                    indexToStatus[i] = .dead
                }
            } else if aliveNeighbors == 3 {
                indexToStatus[i] = .alive
            }
        }

        for index in indexToStatus.keys {
            guard index < models.count , let status = indexToStatus[index] else {
                continue
            }

            models[index].status = status
        }

        let updatedIndexes = indexToStatus.keys.compactMap{ IndexPath(row: $0, section: 0) }
        return updatedIndexes
    }

    func didSelectCell(atIndexPath indexPath: IndexPath) {
        let models = viewModel.cellModels

        guard indexPath.row < models.count else {
            return
        }

        let model = models[indexPath.row]

        if model.status == .alive {
            model.status = .dead
        } else {
            model.status = .alive
        }

        view?.cellsUpdated(at: [indexPath])
    }

    func playGame() {
        guard timer == nil else {
            fatalError("timer was not nil")
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            let indexes = strongSelf.computeNextStage()
            if indexes.count > 0 {
                strongSelf.view?.cellsUpdated(at: indexes)
            }
        })

        timer?.fire()
    }

    func pauseGame() {
        timer?.invalidate()
        timer = nil
    }
}
