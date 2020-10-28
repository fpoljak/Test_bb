//
//  ColorPickerViewController.swift
//  Test_bb
//
//  Created by Frane Poljak on 28/10/2020.
//  Copyright © 2020 Bellabeat. All rights reserved.
//

import UIKit

private class ColorPickerCollectionViewCell: UICollectionViewCell { }

class ColorPickerViewController: UIViewController, ColorPicker {
    
    @IBOutlet weak private var titleLabel: UILabel?
    @IBOutlet weak private var collectionView: UICollectionView?
    
    weak var colorPickerDelegate: ColorPickerDelegate?
    var type: ColorPickerType = .text

    var colors: [UIColor] = [] {
        didSet {
            setupTitle()
            collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        
        collectionView?.register(ColorPickerCollectionViewCell.self, forCellWithReuseIdentifier: "ColorPickerCollectionViewCell")

        collectionView?.reloadData()
    }
    
    private func setupTitle() {
        guard let titleLabel = titleLabel else {
            return
        }
        
        titleLabel.text = "Odaberi boju \(type == .text ? "teksta" :"pozadine")"
        titleLabel.sizeToFit()
    }
}

extension ColorPickerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        colorPickerDelegate?.didPickColor(color: colors[indexPath.row], forType: type)
        dismiss(animated: true, completion: nil)
    }
}

extension ColorPickerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorPickerCollectionViewCell", for: indexPath) as! ColorPickerCollectionViewCell
        cell.contentView.backgroundColor = colors[indexPath.row]
        return cell
    }
}
