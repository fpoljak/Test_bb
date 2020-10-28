//
//  Colors.swift
//  Test_bb
//
//  Created by Frane Poljak on 28/10/2020.
//  Copyright © 2020 Bellabeat. All rights reserved.
//

import Foundation

struct Colors: Codable {
    var backgroundColors: [String]
    var textColors: [String]
}

struct ColorsResponse: Codable {
    var title: String
    var colors: Colors
}
