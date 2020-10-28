//
//  MainViewController.swift
//  Test_bb
//
//  Created by Frane Poljak on 28/10/2020.
//  Copyright © 2020 Bellabeat. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textColorButton: UIButton!
    @IBOutlet private weak var backgroundColorButton: UIButton!
    
    private let defaultTextColor = "CFCFCF"
    private let defaultBackgroundColor = "000000"
    
    private var elementsHidden: Bool = false {
        didSet {
            titleLabel?.isHidden = elementsHidden
            textColorButton?.isHidden = elementsHidden
            backgroundColorButton?.isHidden = elementsHidden
        }
    }
    
    private var backgroundColor: UIColor? {
        get {
            return view.backgroundColor
        }
        set {
            view.backgroundColor = newValue
        }
    }
    
    private var textColor: UIColor! {
        get {
            return titleLabel.textColor
        }
        set {
            titleLabel.textColor = newValue
            textColorButton.setTitleColor(newValue, for: .normal)
            backgroundColorButton.setTitleColor(newValue, for: .normal)
        }
    }
    
    private var _title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
            titleLabel.sizeToFit()
        }
    }
    
    private var backgroundColors: [UIColor]?
    private var textColors: [UIColor]?
    
    private var colors: Colors? {
        didSet {
            setupColors()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show white background initially
        backgroundColor = .white
        
        // hide elements initially until we load a list of colors
        elementsHidden = true
        
        loadColors()
    }
    
    private func loadColors() {
        ColorsService.loadColors { [weak self] (response) in
            guard let response = response else {
                // show some error message
                return
            }
            guard let this = self else {
                return
            }
            
            this._title = response.title
            this.colors = response.colors
        }
    }
    
    private func setupColors() {
        guard let colors = colors else {
            elementsHidden = true
            return
        }
        
        let backgroundColors = colors.backgroundColors.filter { (c) -> Bool in
            return UIColor.isValidHexColor(hexStr: c)
        }
        let textColors = colors.textColors.filter { (c) -> Bool in
            return UIColor.isValidHexColor(hexStr: c)
        }
        
        self.backgroundColors = backgroundColors.map({ (c) -> UIColor in
            return UIColor.fromHexString(hexStr: c)
        })
        self.textColors = textColors.map({ (c) -> UIColor in
            return UIColor.fromHexString(hexStr: c)
        })
        
        let backgroundColor = backgroundColors.randomElement() ?? defaultTextColor // fallback if empty array received
        let textColor = textColors.filter({ (c) -> Bool in
            return !c.elementsEqual(backgroundColor)
        }).randomElement() ?? defaultBackgroundColor
        
        self.backgroundColor = UIColor.fromHexString(hexStr: backgroundColor)
        self.textColor = UIColor.fromHexString(hexStr: textColor)
        
        elementsHidden = false
    }
    
    @IBAction func pickColor(_ sender: UIButton) {
        if textColorButton.isEqual(sender) {
            selectColorFor(.text)
            return
        }
        if backgroundColorButton.isEqual(sender) {
            selectColorFor(.background)
        }
    }
    
    private func selectColorFor(_ type: ColorPickerType) {
        guard let colors = type == .text ? textColors : backgroundColors else {
            return
        }
        
        let vc = ColorPickerViewController()
        vc.colorPickerDelegate = self
        vc.type = type
        
        let disabledColor = type == .text ? backgroundColor : textColor
        
        vc.colors = colors.filter({ (c) -> Bool in
            return !c.isEqual(disabledColor)
        })
        
        present(vc, animated: true, completion: nil)
    }
}

extension MainViewController: ColorPickerDelegate {
    func didPickColor(color: UIColor, forType type: ColorPickerType) {
        switch type {
        case .background:
            backgroundColor = color
            return
        case .text:
            textColor = color
            return
        }
    }
}
