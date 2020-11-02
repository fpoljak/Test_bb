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
    
    var backgroundColors: Driver<[UIColor]> {
        return _backgroundColors.asDriver()
    }
    
    var textColors: Driver<[UIColor]> {
        return _textColors.asDriver()
    }
    
    var colors: Driver<Colors?> {
        return _colors.asDriver()
    }
}
