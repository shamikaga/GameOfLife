//
//  ViewController.swift
//  GameOfLife
//
//  Created by Shamik Aga on 3/31/19.
//  Copyright © 2019 Shamik Aga. All rights reserved.
//

import UIKit

protocol ViewProtocol: class {
    func cellsUpdated(at indexPaths: [IndexPath])
}

class ViewController: UIViewController {

    struct Constants {
        static let cellDimension = CGFloat(20)
        static let minSpacing = CGFloat(1)
        static let border = CGFloat(50)
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!

    fileprivate var controller: ControllerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue.withAlphaComponent(0.5)

        regiserCell()
        initializeController()
    }

    private func regiserCell() {
        collectionView.register(UINib(nibName: "Cell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .clear
    }

    private func initializeController() {
        let viewWidth = view.bounds.size.width - (Constants.border * 2)
        collectionViewWidth.constant = viewWidth

        let cellWidth = Constants.cellDimension + Constants.minSpacing
        let numberOfCellsInRow = Int(viewWidth / cellWidth)

        self.controller = Controller(numberOfCellsInRow: numberOfCellsInRow, inView: self)
    }

    @IBAction func buttonPressed(button: UIButton) {
        guard let title = button.title(for: .normal) else {
            return
        }

        if title == "Play" {
            controller?.playGame()
            button.setTitle("Pause", for: .normal)
        } else {
            controller?.pauseGame()
            button.setTitle("Play", for: .normal)
        }
    }
}

extension ViewController: ViewProtocol {
    
    func cellsUpdated(at indexPaths: [IndexPath]) {
        collectionView.reloadItems(at: indexPaths)
    }
}

extension ViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controller?.numberOfCells ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        if let cell = cell as? Cell,
            let models = controller?.viewModel.cellModels,
            models.count > indexPath.row {
            cell.model = models[indexPath.row]
        }

        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.cellDimension, height: Constants.cellDimension)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controller?.didSelectCell(atIndexPath: indexPath)
    }
}

