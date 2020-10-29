//
//  UIColor+Helpers.swift
//  Test_bb
//
//  Created by Frane Poljak on 28/10/2020.
//  Copyright © 2020 Bellabeat. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red < 256, "Invalid red component")
        assert(green >= 0 && green < 256, "Invalid green component")
        assert(blue >= 0 && blue < 256, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    static func fromHexString(hexStr: String) -> UIColor {
        guard isValidHexColor(hexStr: hexStr), let hex = Int(hexStr.uppercased(), radix: 16) else {
            return UIColor(red: 0, green: 0, blue: 0)
        }
        return UIColor(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
    
    static func isValidHexColor(hexStr: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", "[0-9,A-F,a-f]{6}")
        return predicate.evaluate(with: hexStr)
    }
}
