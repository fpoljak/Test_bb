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

private class ColorPickerCollectionViewCell: UICollectionViewCell {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    private func _init() {
        let layer = contentView.layer
        layer.cornerRadius = 8.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.15
    }   
}

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

        collectionView?.contentInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        
        collectionView?.rx.setDelegate(self).disposed(by: disposeBag)
        
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

extension ColorPickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 64.0) / 3
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
