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
    
    private var colors: Colors? {
        didSet {
            guard let colors = colors else {
                titleLabel?.isHidden = true
                textColorButton?.isHidden = true
                backgroundColorButton?.isHidden = true
                return
            }
            
            let backgroundColors = colors.backgroundColors.filter { (c) -> Bool in
                return UIColor.isValidHexColor(hexStr: c)
            }
            let textColors = colors.textColors.filter { (c) -> Bool in
                return UIColor.isValidHexColor(hexStr: c)
            }
            
            let backgroundColor = backgroundColors.randomElement() ?? defaultTextColor // fallback if empty array received
            let textColor = textColors.filter({ (c) -> Bool in
                return !c.elementsEqual(backgroundColor)
            }).randomElement() ?? defaultBackgroundColor
            
            self.backgroundColor = UIColor.fromHexString(hexStr: backgroundColor)
            self.textColor = UIColor.fromHexString(hexStr: textColor)
            
            titleLabel?.isHidden = false
            textColorButton?.isHidden = false
            backgroundColorButton?.isHidden = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show white background initially
        backgroundColor = .white
        
        // hide initially until we load a list of colors
        titleLabel?.isHidden = true
        textColorButton?.isHidden = true
        backgroundColorButton?.isHidden = true
        
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
}
