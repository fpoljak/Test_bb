//
//  ColorPickerViewController.swift
//  Test_bb
//
//  Created by Frane Poljak on 28/10/2020.
//  Copyright © 2020 Bellabeat. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private class ColorPickerCollectionViewCell: UICollectionViewCell { }

class ColorPickerViewController: UIViewController, ColorPicker {
    
    @IBOutlet weak private var titleLabel: UILabel?
    @IBOutlet weak private var collectionView: UICollectionView?
    
    weak var colorPickerDelegate: ColorPickerDelegate?
    var type: ColorPickerType = .text
    
    var colorObservable: Observable<[UIColor]>?

    var colors: [UIColor] = [] {
        didSet {
            colorObservable = Observable.just(colors)
            setup()
        }
    }
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(ColorPickerCollectionViewCell.self, forCellWithReuseIdentifier: "ColorPickerCollectionViewCell")

        setup()
    }
    
    private func setup() {
        guard colors.count > 0 else {
            return
        }
        setupTitle()
        setupCellConfiguration()
        setupCellTapHandling()
    }
    
    private func setupTitle() {
        guard let titleLabel = titleLabel else {
            return
        }
        
        titleLabel.text = "Odaberi boju \(type == .text ? "teksta" :"pozadine")"
        titleLabel.sizeToFit()
    }
    
    private func setupCellConfiguration() {
        guard let collectionView = collectionView else {
            return
        }
        colorObservable?
            .bind(to: collectionView
                .rx
                .items(cellIdentifier: "ColorPickerCollectionViewCell",
                    cellType: ColorPickerCollectionViewCell.self)) { row, color, cell in
                        cell.contentView.backgroundColor = color
        }
        .disposed(by: disposeBag)
    }
    
    private func setupCellTapHandling() {
        guard let collectionView = collectionView else {
            return
        }
        collectionView
            .rx
            .modelSelected(UIColor.self)
            .subscribe(onNext: { [unowned self] color in
                self.colorPickerDelegate?.didPickColor(color: color, forType: self.type)
                self.dismiss(animated: true, completion: nil)
        })
        .disposed(by: disposeBag)
    }
}
