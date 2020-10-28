//
//  ColorsService.swift
//  Test_bb
//
//  Created by Frane Poljak on 28/10/2020.
//  Copyright © 2020 Bellabeat. All rights reserved.
//

import Foundation
import Alamofire

public class ColorsService {
    @discardableResult
    static func loadColors(completion: @escaping (ColorsResponse?) -> Void) -> DataRequest {
        return ApiService.apiRequest(method: .get, endpoint: "interview.json", completion: completion)
    }
}
