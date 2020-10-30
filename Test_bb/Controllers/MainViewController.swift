//
//  MainViewController.swift
//  Test_bb
//
//  Created by Frane Poljak on 28/10/2020.
//  Copyright © 2020 Bellabeat. All rights reserved.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textColorButton: UIButton!
    @IBOutlet weak var backgroundColorButton: UIButton!
    
    private let defaultTextColor = "CFCFCF"
    private let defaultBackgroundColor = "FFFFFF"
    
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
    
    var backgroundColors: [UIColor]?
    var textColors: [UIColor]?
    
    var colors: Colors? {
        didSet {
            setupColors()
            setupEvents()
        }
    }
    
    let disposeBag = DisposeBag()
}

//MARK: View lifecycle
extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show white background initially
        backgroundColor = .white
        
        // hide elements initially until we load a list of colors
        elementsHidden = true
        
        loadColors()
    }
}

//MARK: Data loading
extension MainViewController {
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

//MARK: Setup
extension MainViewController {
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
        
        // initial colors
        let backgroundColor = backgroundColors.randomElement() ?? defaultTextColor // fallback if empty array received
        let textColor = textColors.filter({ (c) -> Bool in
            return !c.elementsEqual(backgroundColor)
        }).randomElement() ?? defaultBackgroundColor // fallback if empty array received
        
        self.backgroundColor = UIColor.fromHexString(hexStr: backgroundColor)
        self.textColor = UIColor.fromHexString(hexStr: textColor)
        
        elementsHidden = false
    }
    
    func setupEvents() {
        textColorButton.rx.tap.debounce(.milliseconds(5), scheduler: MainScheduler.instance)
            .flatMapLatest { [unowned self] _ -> Observable<UIColor> in
                return self.selectColorFor(.text)
            }
            .do(onNext: { [unowned self] _ in
                self.dismiss(animated: true, completion: nil)
            })
            .subscribe(onNext: { [unowned self] (newColor) in
                self.textColor = newColor
            })
            .disposed(by: disposeBag)
        
        backgroundColorButton.rx.tap.debounce(.milliseconds(5), scheduler: MainScheduler.instance)
            .flatMapLatest { [unowned self] _ -> Observable<UIColor> in
                return self.selectColorFor(.background)
            }
            .do(onNext: { [unowned self] _ in
                self.dismiss(animated: true, completion: nil)
            })
            .subscribe(onNext: { [unowned self] (newColor) in
                self.backgroundColor = newColor
            })
            .disposed(by: disposeBag)
    }
    
    private func selectColorFor(_ type: ColorPickerType) -> PublishSubject<UIColor> {
        let colors = (type == .text ? textColors : backgroundColors) ?? []
        
        let vc = ColorPickerViewController()
        vc.type = type
        
        let disabledColor = type == .text ? backgroundColor : textColor
        
        vc.colors = colors.filter({ (c) -> Bool in
            return !c.isEqual(disabledColor)
        })
        
        present(vc, animated: true, completion: nil)
        
        return vc.selectedColor
    }
}
