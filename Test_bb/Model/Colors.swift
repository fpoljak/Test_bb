//
//  Colors.swift
//  Test_bb
//
//  Created by Frane Poljak on 28/10/2020.
//  Copyright © 2020 Bellabeat. All rights reserved.
//

import Foundation

struct Colors: Decodable {
    var backgroundColors: [String]
    var textColors: [String]
}

struct ColorsResponse: Decodable {
    var title: String
    var colors: Colors
}
