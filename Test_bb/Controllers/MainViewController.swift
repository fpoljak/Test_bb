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
    
    var viewModel: MainViewModel!
    
    let disposeBag = DisposeBag()
}

//MARK: View lifecycle
extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MainViewModel()
        
        initialSetup()
        
        viewModel.loadColors()
    }
}

//MARK: Setup
extension MainViewController {
    func initialSetup() {
        viewModel.elementsHidden.drive(onNext: { [unowned self] newValue in
            self.titleLabel?.isHidden = newValue
            self.textColorButton?.isHidden = newValue
            self.backgroundColorButton?.isHidden = newValue
        }).disposed(by: disposeBag)
        
        viewModel.backgroundColor.drive(onNext: { [unowned self] newValue in
            self.view.backgroundColor = newValue
        }).disposed(by: disposeBag)
        
        viewModel.textColor.drive(onNext: { [unowned self] newValue in
            self.titleLabel.textColor = newValue
            self.textColorButton.setTitleColor(newValue, for: .normal)
            self.backgroundColorButton.setTitleColor(newValue, for: .normal)
        }).disposed(by: disposeBag)
        
        viewModel.title.drive(onNext: { [unowned self] newValue in
            self.titleLabel.text = newValue
            self.titleLabel.sizeToFit()
        }).disposed(by: disposeBag)
        
        viewModel.colors.drive(onNext: { [unowned self] newValue in
            guard let _ = newValue else {
                return
            }
            self.setupEvents()
        }).disposed(by: disposeBag)
    }
    
    private func setupEvents() {
        setColorPickerOpenOnTapForButton(textColorButton, colorPickerType: .text)
        setColorPickerOpenOnTapForButton(backgroundColorButton, colorPickerType: .background)
    }
    
    private func setColorPickerOpenOnTapForButton(_ button: UIButton, colorPickerType type: ColorPickerType) {
        button.rx.tap.debounce(.milliseconds(5), scheduler: MainScheduler.instance)
            .flatMapLatest { [unowned self] _ -> Observable<UIColor> in
                return self.selectColorFor(type)
            }
            .do(onNext: { [unowned self] _ in
                self.dismiss(animated: true, completion: nil)
            })
            .subscribe(onNext: { [unowned self] (newColor) in
                switch(type) {
                case .text:
                    self.viewModel._textColor.accept(newColor)
                case .background:
                    self.viewModel._backgroundColor.accept(newColor)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func selectColorFor(_ type: ColorPickerType) -> PublishSubject<UIColor> {
        let colors = type == .text ? viewModel._textColors.value : viewModel._backgroundColors.value
        
        let vc = ColorPickerViewController()
        vc.type = type
        
        let disabledColor = type == .text ? self.viewModel._backgroundColor.value : self.viewModel._textColor.value
        
        vc.colors = colors.filter({ !$0.isEqual(disabledColor) })
        
        present(vc, animated: true, completion: nil)
        
        return vc.selectedColor
    }
}
