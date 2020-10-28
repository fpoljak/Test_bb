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
        
    }
}
