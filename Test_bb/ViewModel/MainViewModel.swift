//
//  MainViewModel.swift
//  Test_bb
//
//  Created by Frane Poljak on 02/11/2020.
//  Copyright © 2020 Bellabeat. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    private let disposeBag = DisposeBag()
    
    static private let defaultTextColor = "CFCFCF"
    static private let defaultBackgroundColor = "FFFFFF"
    
    let _elementsHidden = BehaviorRelay<Bool>(value: false)
    let _backgroundColor = BehaviorRelay<UIColor>(value: .white)
    let _textColor = BehaviorRelay<UIColor>(value: UIColor.fromHexString(hexStr: defaultTextColor))
    let _title = BehaviorRelay<String>(value: "")
    let _backgroundColors = BehaviorRelay<[UIColor]>(value: [])
    let _textColors = BehaviorRelay<[UIColor]>(value: [])
    let _colors = BehaviorRelay<Colors?>(value: nil)
    
    var elementsHidden: Driver<Bool> {
        return _elementsHidden.asDriver()
    }
    
    var backgroundColor: Driver<UIColor> {
        return _backgroundColor.asDriver()
    }
    
    var textColor: Driver<UIColor> {
        return _textColor.asDriver()
    }
    
    var title: Driver<String> {
        return _title.asDriver()
    }
    
    var colors: Driver<Colors?> {
        return _colors.asDriver()
    }
    
    init() { }
    
    func loadColors() {
        ColorsService.loadColors().subscribe(onNext: { [weak self] response in
            guard let response = response else {
                // show some error message
                return
            }
            guard let this = self else {
                return
            }

            this._title.accept(response.title)
            this._colors.accept(response.colors)
            this.setupColors()
        }, onError: ApiService.defaultErrorHandler).disposed(by: disposeBag)
    }
    
    private func setupColors() {
        guard let colors = _colors.value else {
            _elementsHidden.accept(true)
            return
        }
        
        let backgroundColors = colors.backgroundColors.filter { UIColor.isValidHexColor(hexStr: $0) }
        let textColors = colors.textColors.filter { UIColor.isValidHexColor(hexStr: $0) }
        
        _backgroundColors.accept(backgroundColors.map { UIColor.fromHexString(hexStr: $0) })
        _textColors.accept(textColors.map { UIColor.fromHexString(hexStr: $0) })
        
        // initial colors
        let backgroundColor = backgroundColors.randomElement() ?? MainViewModel.defaultTextColor // fallback if empty array received
        let textColor = textColors
            .filter({ !$0.elementsEqual(backgroundColor) })
            .randomElement() ?? MainViewModel.defaultBackgroundColor // fallback if empty array received
        
        _backgroundColor.accept(UIColor.fromHexString(hexStr: backgroundColor))
        _textColor.accept(UIColor.fromHexString(hexStr: textColor))
        
        _elementsHidden.accept(false)
    }
}
