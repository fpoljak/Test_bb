//
//  ColorPicker.swift
//  Test_bb
//
//  Created by Frane Poljak on 28/10/2020.
//  Copyright © 2020 Bellabeat. All rights reserved.
//

import UIKit

public enum ColorPickerType {
    case text
    case background
}

protocol ColorPicker: AnyObject {
    var colorPickerDelegate: ColorPickerDelegate? { get set }
    var colors: [UIColor] { get set }
    var type: ColorPickerType { get set }
}

protocol ColorPickerDelegate: AnyObject {
    func didPickColor(color: UIColor, forType type: ColorPickerType)
}
